{ config, pkgs, ... }:
{
  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
    type = "disk";
    preCreateHook = ''
      if [ ! -e /tmp/disk-encryption.key ]
      then
        echo "[SOPH] !!! Inserting Fake Key... !!!"
        # tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32 > /tmp/disk-encryption.key
        printf dummy > /tmp/disk-encryption.key
        echo "Key:"
        cat /tmp/disk-encryption.key
      fi
    '';
    postCreateHook = ''
      mkdir /tmpmnt
      mount /dev/mapper/encwyptwed /tmpmnt
      cp /tmp/disk-encryption.key /tmpmnt/disk-encryption.key
      umount /tmpmnt
      rmdir /tmpmnt
    '';
    content = {
      type = "gpt";
      partitions = {
        boot = {
          size = "1G";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
          };
        };
        root = {
          size = "100%";
          content = {
            type = "luks";
            name = "encwyptwed";
            settings.allowDiscards = true;
            passwordFile = "/tmp/disk-encryption.key";
            content = {
              type = "filesystem";
              format = "xfs";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };
  boot.initrd.systemd.enable = true;
  boot.initrd.availableKernelModules = [
    "tpm_tis"
    "tpm"
  ];
  boot.initrd.systemd.tpm2.enable = true;
  boot.initrd.systemd.emergencyAccess = true;

  systemd.services.enroll-tpm = {
    description = "Enroll LUKS key to TPM2";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.systemd}/bin/systemd-cryptenroll --tpm2-pcrs=0 --tpm2-device=auto --unlock-key-file=/disk-encryption.key";
      RemainAfterExit = "yes";
    };
    wantedBy = [ "multi-user.target" ];
  };

  environment.systemPackages = with pkgs; [
    cryptsetup
    tpm2-tools
    tpm2-tss
  ];
}
