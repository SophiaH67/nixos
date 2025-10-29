{ config, lib, pkgs, ...}:
{
  options.sophices.boot-unlock.enable = lib.mkEnableOption "Soph boot-unlock";

  # ssh-keygen -t rsa -N "" -f /boot/ssh_host_rsa_key
  config = lib.mkIf config.sophices.boot-unlock.enable {
    boot.kernelParams = [ "ip=dhcp" ];
    boot.initrd = {
      availableKernelModules = [ "r8169" ];
      network = {
        enable = true;
        ssh = {
          enable = true;
          port = 22;
          authorizedKeys = config.users.users.sophia.openssh.authorizedKeys.keys;
          hostKeys = [ "/boot/ssh_host_rsa_key" ];
          shell = "/bin/cryptsetup-askpass";
        };
      };
    };
  };
}
