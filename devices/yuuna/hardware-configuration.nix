{ lib, config, pkgs, ... }:
{
  boot.loader.grub.enable = false;
  boot.loader.systemd-boot.enable = false;
  boot.loader.generic-extlinux-compatible.enable = true;

  networking.networkmanager.enable = true;
  networking.networkmanager.wifi.powersave = false;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888";
      fsType = "ext4";
    };

  fileSystems."/boot/firmware" =
    { device = "/dev/disk/by-uuid/2178-694E";
      fsType = "vfat";
    };

  boot.kernelPackages = pkgs.linuxPackages;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}