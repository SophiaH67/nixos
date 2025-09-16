{ config, pkgs, ... }:
{
  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
    type = "disk";
    preCreateHook = ''
      if [ ! -e /tmp/disk-encryption.key ]
      then
        echo "[SOPH] !!! Inserting Fake Key... !!!"
        tr -dc 'A-Za-z0-9' < /dev/urandom | head -c 32 > /tmp/disk-encryption.key
        echo "Key:"
        cat /tmp/disk-encryption.key
      fi
    '';
    postCreateHook = ''
      cp /tmp/disk-encryption.key /etc/disk-encryption.key
      chmod 0400 /etc/disk-encryption.key
      # TODO: Let's try to boot this with a real TPM, I think qemu might just suck
      # also, look at https://archive.fosdem.org/2023/schedule/event/nix_and_nixos_towards_secure_boot/attachments/slides/5484/export/events/attachments/nix_and_nixos_towards_secure_boot/slides/5484/fosdem_lanzaboote_slides.pdf
      # systemd-cryptenroll --tpm2-pcrs=7 --tpm2-device=auto --unlock-key-file=/tmp/disk-encryption.key
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
              format = "ext4";
              mountpoint = "/";
            };
          };
        };
      };
    };
  };

  systemd.services.enroll-tpm = {
    description = "Enroll LUKS key to TPM2";
    serviceConfig = {
      Type = "oneshot";
      ExecStart = ''${pkgs.systemd}/bin/systemd-cryptenroll --tpm2-pcrs=7 --tpm2-device=auto --unlock-key-file=/etc/disk-encryption.key'';
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
