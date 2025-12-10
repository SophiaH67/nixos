{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:

{
  imports = [ inputs.niri.nixosModules.niri ];

  options.sophrams.niri.enable = lib.mkEnableOption "Soph niri";

  config = lib.mkIf config.sophrams.niri.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.package = pkgs.niri-unstable;

    programs.niri.enable = true;

    home-manager.users.sophia =
      { pkgs, ... }:
      {
        programs.niri.config = builtins.readFile ./config.kdl;
      };
  };
}
