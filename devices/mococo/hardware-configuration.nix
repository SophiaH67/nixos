{ config, pkgs, ... }:
{
  boot.kernelPackages = pkgs.linuxKernel.packages.linux;
  # boot.extraModulePackages = [ linuxKernel.packages.linux_zen.zfs_2_3 ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zfs ];

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}