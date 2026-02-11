{
  config,
  lib,
  nixos-config,
  ...
}:
{
  options.soph.embedded.enable = lib.mkOption {
    type = lib.types.bool;
    default = nixos-config.soph.embedded.enable;
    description = "Soph Homemanager Embedded stuff (low performance)";
  };

  config = lib.mkIf config.soph.embedded.enable {
    programs.zsh.syntaxHighlighting.enable = lib.mkForce false;
    programs.atuin.enable = lib.mkForce false;
  };
}
