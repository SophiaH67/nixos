{ config, lib, pkgs, ...}:
{
  options.sophrams.krita.enable = lib.mkEnableOption "Soph Krita";

  config = lib.mkIf config.sophrams.krita.enable {
    environment.systemPackages = with pkgs; [ krita ];
  };
}