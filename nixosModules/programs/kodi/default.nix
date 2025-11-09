{ config, lib, pkgs, inputs, ...}:
{
  options.sophrams.kodi.enable = lib.mkEnableOption "Soph Kodi";

  config = lib.mkIf config.sophrams.kodi.enable {
    environment.systemPackages = [
      (pkgs.kodi.withPackages (kodiPkgs: with kodiPkgs; [
        jellyfin
      ]))
    ];  
  };
}
