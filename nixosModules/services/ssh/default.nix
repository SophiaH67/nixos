{
  config,
  lib,
  ...
}:
{
  options.sophices.ssh.enable = lib.mkEnableOption "Soph Ssh";

  config = lib.mkIf config.sophices.ssh.enable {
    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PrintMotd = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AllowGroups = [
          "wheel"
          "sshable"
        ];
      };
      allowSFTP = true;
      banner = ''
        -=-=- Establishing encrypted connection... -=-=-
        [C]: Requesting Frontier Malitia administration for node ${config.networking.hostName}
        [S]: Receiving encrypted connection...
        [S]: Provide identity:
        [C]:
      '';
      #TODO: Set up a jail for failure to authenticate
    };

    users.groups.sshable = { };
  };
}
