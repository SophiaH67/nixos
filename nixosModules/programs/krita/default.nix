{ config, lib, pkgs, ...}:
{
  options.sophrams.krita.enable = lib.mkEnableOption "Soph Krita";

  config = lib.mkIf config.soph.drawing.enable {
    environment.systemPackages = with pkgs; [ krita ];
  };
}