{ config, ... }:
{
  disko.devices.disk.main = {
    device = "/dev/nvme0n1";
    type = "disk";
    preCreateHook = ''
      if [ ! -e /tmp/disk-encryption.key ]
      then
        echo "[SOPH] !!! Inserting Fake Key... !!!"
        echo "DUMMYKEY" > /tmp/disk-encryption.key
      fi
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
}
