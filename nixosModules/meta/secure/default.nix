{ config, lib, pkgs, ...}:
{
  options.soph.secure.enable = lib.mkEnableOption "Soph Secure Mode";

  config = lib.mkIf config.soph.secure.enable {
    boot.loader.systemd-boot.enable = lib.mkForce false;

    # First, create keys with sudo sbctl create-keys
    # Then, reboot and enter setup mode (wipe all keys)
    # Finally, enroll with sudo sbctl enroll-keys --microsoft
    boot.lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    boot.loader.efi.canTouchEfiVariables = true;

    # For gnome security panel
    services.fwupd.enable = true;

    # Forcefully disable X, since it's super insecure
    services.xserver.enable = lib.mkForce false;
  };
}
