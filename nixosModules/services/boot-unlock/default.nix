{ config, lib, pkgs, ...}:
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
          port = 22;
          authorizedKeys = config.users.users.sophia.openssh.authorizedKeys.keys;
          hostKeys = [ "/boot/ssh_host_rsa_key" ];
          shell = "/bin/cryptsetup-askpass";
        };

        postCommands = lib.mkIf config.sophices.boot-unlock.tor (let
          torRc = (pkgs.writeText "tor.rc" ''
            DataDirectory /etc/tor
            SOCKSPort 127.0.0.1:9050 IsolateDestAddr
            SOCKSPort 127.0.0.1:9063
            HiddenServiceDir /boot/onion
            HiddenServicePort 22 127.0.0.1:22
          '');
        in ''
          echo "tor: preparing onion folder"
          # have to do this otherwise tor does not want to start
          chmod -R 700 /etc/tor

          echo "make sure localhost is up"
          ip a a 127.0.0.1/8 dev lo
          ip link set lo up

          echo "tor: starting tor"
          tor -f ${torRc} --verify-config
          tor -f ${torRc} &
        '');
      };

      extraUtilsCommands = lib.mkIf config.sophices.boot-unlock.tor ''
        copy_bin_and_libs ${pkgs.tor}/bin/tor
      '';
    };
  };
}
