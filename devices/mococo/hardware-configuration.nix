{
  boot.kernelPackages = linuxKernel.packages.linux;
  # boot.extraModulePackages = [ linuxKernel.packages.linux_zen.zfs_2_3 ];
  boot.extraModulePackages = with config.boot.kernelPackages; [ zfs ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = true;
}