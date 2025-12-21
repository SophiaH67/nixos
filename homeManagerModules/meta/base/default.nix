{
  config,
  lib,
  ...
}:
{
  options.soph.base.enable = lib.mkEnableOption "Soph Homemanager Base";

  config = lib.mkIf config.soph.base.enable {
    home.stateVersion = "23.11";
    
    sophrams.atuin.enable = true;
    sophrams.zsh.enable = true;

    age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa" ];
  };
}
