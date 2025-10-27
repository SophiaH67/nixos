{ config, lib, pkgs, ...}:
{
  options.soph.gaming.enable = lib.mkEnableOption "Soph Gaming Stuff";

  config = lib.mkIf config.soph.gaming.enable {
    sophrams.anime-game.enable = lib.mkDefault true;
  };
}
