{ config, pkgs, ... }:
{
  imports = [
    ../../common/apps/chromium.nix
    ../../common/apps/tailscale.nix
  ];
  networking.hostName = "yuuna";
  networking.domain = "dev.sophiah.gay";

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;
  services.displayManager.gdm.autoSuspend = false;


  networking.networkmanager.enable = true;

  environment.systemPackages = with pkgs; [
    networkmanager
  ];

  # Enable sound with pipewire.
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;
  };
}