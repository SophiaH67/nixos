{
  config,
  lib,
  pkgs,
  modulesPath,
  ...
}:
{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "ahci"
    "usbhid"
  ];
  boot.initrd.kernelModules = [ "dm-snapshot" ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];
  boot.blacklistedKernelModules = [
    "nova_core"
    "nouveau"
  ];
  boot.kernelPackages = pkgs.linuxPackages_6_17;
  networking.hostId = "9c28ba10"; # Needed for zfs

  hardware.graphics.enable = true;
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    open = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  fileSystems."/" = {
    device = "Fuwawa/local/root";
    fsType = "zfs";
  };

  fileSystems."/nix" = {
    device = "Fuwawa/local/nix";
    fsType = "zfs";
  };

  fileSystems."/persist" = {
    device = "Fuwawa/local/persist";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/media/music/shared/Tracks" = {
    device = "/Fuwawa/home/sophia/sync/Tracks";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/B1F1-7CDC";
    fsType = "vfat";
    options = [
      "fmask=0077"
      "dmask=0077"
    ];
  };

  fileSystems."/mnt/user" = {
    device = "overlay";
    fsType = "overlay";
    depends = [ "/persist" ];
    options = [
      "lowerdir=/Fuwawa/old/acache:/Fuwawa/old/disk1:/Fuwawa/old/disk2:/Fuwawa/old/disk3:/Fuwawa/old/disk4:/Fuwawa/old/disk5:/Fuwawa/old/disk6"
    ];
  };

  systemd.enableEmergencyMode = false;

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
