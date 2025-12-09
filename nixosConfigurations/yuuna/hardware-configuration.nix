{
  lib,
  config,
  pkgs,
  ...
}:
{
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;
  networking.networkmanager.wifi.backend = "iwd";
  networking.wireless.iwd.enable = true;
  systemd.services.iwd.serviceConfig.Restart = "always";
  hardware = {
    enableRedistributableFirmware = true;
    firmware = [ pkgs.wireless-regdb ];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
    fsType = "ext4";
  };

  fileSystems."/boot/firmware" = {
    device = "/dev/disk/by-uuid/2178-694E";
    fsType = "vfat";
  };

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  boot.kernelParams = [ "snd_bcm2835.enable_hdmi=1" ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}
