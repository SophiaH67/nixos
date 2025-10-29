{ config, lib, pkgs, ...}:
{
  options.sophrams.signal.enable = lib.mkEnableOption "Soph Signal";

  config = lib.mkIf config.sophrams.signal.enable {
    environment.systemPackages = [
      pkgs.signal-desktop
    ];
  };
}
