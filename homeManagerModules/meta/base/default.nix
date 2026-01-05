{
  config,
  lib,
  nixos-config,
  ...
}:
{
  options.soph.base.enable = lib.mkEnableOption "Soph Homemanager Base";

  config = lib.mkIf config.soph.base.enable {
    home.stateVersion = "23.11";

    sophrams.atuin.enable = true;
    sophrams.zsh.enable = true;

    soph.vr.enable = lib.mkIf nixos-config.soph.vr.enable (lib.mkDefault true);

    age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa" ];

    home.file.".ssh/id_ed25519_sk.pub".source = ../../../secrets/id_ed25519_sk.pub;
    home.file.".ssh/id_ed25519_sk".source = ../../../secrets/id_ed25519_sk;
  };
}
