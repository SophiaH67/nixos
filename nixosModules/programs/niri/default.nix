{ pkgs, lib, config, inputs, ...}:

{
  options.sophrams.niri.enable = lib.mkEnableOption "Soph niri";

  config = lib.mkIf config.sophrams.niri.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.package = pkgs.niri-unstable;

    programs.niri.enable = true;
  };
}