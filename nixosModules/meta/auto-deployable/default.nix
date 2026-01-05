{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.auto-deployable.enable = lib.mkEnableOption "Soph Auto-deployable";

  config = lib.mkIf config.soph.auto-deployable.enable {
    users.groups.forgejo = { };

    users.users.forgejo = {
      description = "Forgejo CI (for automatic deploys)";
      extraGroups = [
        "wheel"
      ];
      group = "forgejo";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINxRWP14VnqsOH7ukPduWmotPLkkGzoEq4kr/URWQCoY root@244cfb52066d"
      ];
      # Still needs a shell for deploy-rs :/
      isNormalUser = true;
      packages = with pkgs; [ zsh ];
      shell = pkgs.zsh;
      uid = 967;
    };

    sophices.ssh.enable = true;
  };
}
