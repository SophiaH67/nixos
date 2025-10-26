{ config, lib, pkgs, ...}:
{
  options.soph.drawing.enable = lib.mkEnableOption "Soph Drawing Stuff";

  config = lib.mkIf config.soph.drawing.enable {
    sophrams.krita.enable = lib.mkDefault true;
    hardware.opentabletdriver.enable = lib.mkDefault true;
  };
}