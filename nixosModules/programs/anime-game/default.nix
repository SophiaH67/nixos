{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.sophrams.anime-game.enable = lib.mkEnableOption "Soph Anime Game";

  imports = [
    inputs.aagl.nixosModules.default
  ];

  config = lib.mkIf config.sophrams.anime-game.enable {
    programs.anime-game-launcher.enable = true;
  };
}
