{ pkgs, lib, config, inputs, ...}:

{
  imports = [ inputs.niri.nixosModules.niri ];

  options.sophrams.niri.enable = lib.mkEnableOption "Soph niri";

  config = lib.mkIf config.sophrams.niri.enable {
    nixpkgs.overlays = [ inputs.niri.overlays.niri ];
    programs.niri.package = pkgs.niri-unstable;

    programs.niri.enable = true;

    home-manager.users.sophia = { pkgs, ... }: {
      programs.niri.settings = {
        environment = {
          "NIXOS_OZONE_WL" = "1";
        } // config.environment.sessionVariables;

        binds = {
          "Mod+1".action.focus-workspace = 1;
          "Mod+2".action.focus-workspace = 2;
          "Mod+3".action.focus-workspace = 3;
          "Mod+4".action.focus-workspace = 4;
          "Mod+5".action.focus-workspace = 5;
          "Mod+6".action.focus-workspace = 6;
          "Mod+7".action.focus-workspace = 7;
          "Mod+8".action.focus-workspace = 8;
          "Mod+9".action.focus-workspace = 9;

          "Mod+Shift+Left".action.focus-monitor = "left";
          "Mod+Shift+Down".action.focus-monitor = "down";
          "Mod+Shift+Up".action.focus-monitor = "up";
          "Mod+Shift+Right".action.focus-monitor = "right";
          "Mod+Shift+H".action.focus-monitor = "left";
          "Mod+Shift+J".action.focus-monitor = "down";
          "Mod+Shift+K".action.focus-monitor = "up";
          "Mod+Shift+L".action.focus-monitor = "right";
        };
      };
    };
  };
}