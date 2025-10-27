{ config, pkgs, ... }:
{
  sophices.tailscale.enable = true;
  options.sophrams.chromium.enable = true;

  networking.hostName = "yuuna";
  networking.domain = "dev.sophiah.gay";

  powerManagement.cpuFreqGovernor = "performance";
  hardware.deviceTree.enable = true;
  hardware.deviceTree.filter = "bcm2711-rpi-4*.dtb";
  hardware.raspberry-pi."4" = {
    fkms-3d.enable = true;
  };

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = false;
  services.displayManager.gdm.enable = false;
  services.displayManager.gdm.autoSuspend = false;
  services.xserver.displayManager.lightdm.enable = true;

  services.xserver = {
    enable = true;
    desktopManager = {
      xterm.enable = true;
      xfce.enable = true;
    };
  };
  services.displayManager.defaultSession = "xfce";

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