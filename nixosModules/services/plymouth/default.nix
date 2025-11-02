{ config, lib, pkgs, ...}:
{
  options.sophices.plymouth.enable = lib.mkEnableOption "Soph Plymouth";

  config = lib.mkIf config.sophices.plymouth.enable {
    boot = {
      plymouth.enable = true;
      plymouth.theme = "soph-mes";
      plymouth.themePackages = [ (pkgs.callPackage ./theme.nix pkgs) ];
      initrd.systemd.enable = true;

      consoleLogLevel = 3;
      initrd.verbose = false;
      kernelParams = [
        "quiet"
        "splash"
        "boot.shell_on_fail"
        "udev.log_priority=3"
        "rd.systemd.show_status=auto"
      ];
      # Hide the OS choice for bootloaders.
      # It's still possible to open the bootloader list by pressing any key
      # It will just not appear on screen unless a key is pressed
      loader.timeout = 0;
    };
  };
}
