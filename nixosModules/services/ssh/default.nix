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
      banner =
        let
          shortName = lib.toUpper (builtins.substring 0 3 config.networking.hostName);
        in
        ''
          -=-=- Establishing encrypted connection... -=-=-
          [???]: Requesting Frontier Malitia administration for node ${lib.toUpper config.networking.hostName}
          [${shortName}]: Receiving encrypted connection from ???...
          [${shortName}]: Identification required for ???
          [???]:
        '';
      #TODO: Set up a jail for failure to authenticate
    };

    services.fail2ban = {
      enable = true;

      bantime-increment = {
        enable = true;
      };
    };

    users.groups.sshable = { };
  };
}
