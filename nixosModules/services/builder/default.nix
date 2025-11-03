{ config, lib, pkgs, ...}:
{
  options.sophices.builder.enable = lib.mkEnableOption "Soph Builder System";

  config = lib.mkIf config.sophices.builder.enable {
    users.users.soph-builder = {
      isSystemUser = true;
      group = "soph-builder";
      useDefaultShell = true;

      openssh.authorizedKeys.keyFiles = [ ./soph-builder.id_ed25519.pub ];
    };

    users.groups.soph-builder = {};

    nix.settings.trusted-users = [ "soph-builder" ];
  };
}
