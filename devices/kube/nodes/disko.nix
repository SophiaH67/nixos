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
      mkdir /tmpmnt
      mount -t bcachefs /dev/disk/by-partlabel/disk-main-root /tmpmnt
      cp /tmp/disk-encryption.key /tmpmnt/etc/disk-encryption.key
      umount /tmpmnt
      rmdir /tmpmnt

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
            type = "bcachefs";
            label = "encwyptwed";
            # mountpoint = "/";
            # passwordFile = "/tmp/disk-encryption.key";
            
            filesystem = "encwyptwed";
          };
        };
      };
    };
  };

  disko.devices.bcachefs_filesystems.encwyptwed = {
    type = "bcachefs_filesystem";
    passwordFile = "/etc/disk-encryption.key";
    extraFormatArgs = [
      "--compression=lz4"
      "--background_compression=lz4"
      "--discard"
    ];
    subvolumes = {
    # Subvolume name is different from mountpoint.
      "subvolumes/root" = {
        mountpoint = "/";
        mountOptions = [
          "verbose"
        ];
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
