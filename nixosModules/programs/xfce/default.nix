{
  config,
  lib,
  ...
}:
{
  options.sophrams.xfce.enable = lib.mkEnableOption "Soph Xfce";

  config = lib.mkIf config.sophrams.xfce.enable {
    services.displayManager.autoLogin.enable = true;
    services.displayManager.autoLogin.user = "sophia";

    services.xserver = {
      enable = true;
      desktopManager = {
        xterm.enable = false;
        xfce.enable = true;
      };
    };
  };
}
