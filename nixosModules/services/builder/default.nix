{ config, lib, pkgs, ...}:
{
  options.sophices.builder.enable = lib.mkEnableOption "Soph Builder System";

  config = lib.mkIf config.sophices.builder.enable {
    users.users.soph-builder = {
      isSystemUser = true;
      group = "soph-builder";
      useDefaultShell = true;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLd+fLmg2masZl3fIUGlVAIahLoMFHA1BIZIYa4bTcq soph-builder"
      ];
    };

    users.groups.soph-builder = {};

    nix.settings.trusted-users = [ "soph-builder" ];
  };
}
