{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophices.boot-unlock.enable = lib.mkEnableOption "Soph boot-unlock";
  options.sophices.boot-unlock.tor = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable tor (needs imperative command to be ran for generating keys)";
  };

  # ssh-keygen -t rsa -N "" -f /boot/ssh_host_rsa_key
  config = lib.mkIf config.sophices.boot-unlock.enable {
    boot.kernelParams = [ "ip=dhcp" ];
    boot.initrd = {
      availableKernelModules = [ "r8169" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 2222;
          authorizedKeys = config.users.users.sophia.openssh.authorizedKeys.keys;
          hostKeys = [ "/boot/ssh_host_rsa_key" ];
        };

        postCommands = ''
          # Import all pools
          zpool import -a

          # Add the load-key command to the .profile
          echo "zfs load-key -a; killall zfs" >> /root/.profile
        '';
      };

      extraUtilsCommands = lib.mkIf config.sophices.boot-unlock.tor ''
        copy_bin_and_libs ${pkgs.tor}/bin/tor
      '';
    };
  };
}
