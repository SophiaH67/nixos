{ lib, config, pkgs, ... }:
{
  networking.networkmanager.enable = true;

  fileSystems."/" =
    { device = "/dev/disk/by-uuid/44444444-4444-4444-8888-888888888888`";
      fsType = "ext4";
    };

  fileSystems."/boot" =
    { device = "/dev/disk/by-uuid/2178-694E";
      fsType = "vfat";
    };

  boot.kernelPackages = pkgs.linuxPackages;

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";
}