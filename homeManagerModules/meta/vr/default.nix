{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.vr.enable = lib.mkEnableOption "Soph Homemanager VR Base";

  config = lib.mkIf config.soph.vr.enable {
    soph.dev-vr.enable = true; # All VR users rn are dev users too

    xdg.configFile."openvr/openvrpaths.vrpath".force = true;
    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
      {
        "config" :
        [
          "~/.local/share/Steam/config"
        ],
        "external_drivers" : null,
        "jsonid" : "vrpathreg",
        "log" :
        [
          "~/.local/share/Steam/logs"
        ],
        "runtime" :
        [
          "${pkgs.opencomposite}/lib/opencomposite"
        ],
        "version" : 1
      }
    '';

    xdg.configFile."wlxoverlay/openxr_actions.json5".force = true;
    xdg.configFile."wlxoverlay/openxr_actions.json5".source = ./vr-overlaybinds.json5;
  };
}
