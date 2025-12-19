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

  fileSystems."/" = {
    device = "/dev/mapper/ubuntu--vg-shioriin";
    fsType = "ext4";
  };

  fileSystems."/Fuwawa/media/music/shared/Tracks" = {
    device = "/Fuwawa/home/sophia/sync/Tracks";
    fsType = "none";
    options = [ "bind" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/f877eb75-e3a8-4ae8-a00b-51412babb35d";
    fsType = "ext4";
  };

  fileSystems."/boot/efi" = {
    device = "/dev/disk/by-uuid/B1F1-7CDC";
    fsType = "vfat";
    options = [
      "fmask=0022"
      "dmask=0022"
    ];
  };

  fileSystems."/Fuwawa/unenc" = {
    device = "Fuwawa/unenc";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa" = {
    device = "Fuwawa";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/appdata" = {
    device = "Fuwawa/appdata";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/archive" = {
    device = "Fuwawa/archive";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/archive/ex-machina-backup" = {
    device = "Fuwawa/archive/ex-machina-backup";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/config" = {
    device = "Fuwawa/config";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/home" = {
    device = "Fuwawa/home";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/home/sophia" = {
    device = "Fuwawa/home/sophia";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/isos" = {
    device = "Fuwawa/isos";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/media" = {
    device = "Fuwawa/media";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/nix" = {
    device = "Fuwawa/nix";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/old" = {
    device = "Fuwawa/old";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/photos" = {
    device = "Fuwawa/photos";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/vm-disks" = {
    device = "Fuwawa/vm-disks";
    fsType = "zfs";
  };

  fileSystems."/Fuwawa/vm-disks/games" = {
    device = "Fuwawa/vm-disks/games";
    fsType = "zfs";
  };

  fileSystems."/mnt/user" = {
    device = "overlay";
    fsType = "overlay";
    depends = [
      "/Fuwawa/old"
    ];
    options = [
      "lowerdir=/Fuwawa/old/acache:/Fuwawa/old/disk1:/Fuwawa/old/disk2:/Fuwawa/old/disk3:/Fuwawa/old/disk4:/Fuwawa/old/disk5:/Fuwawa/old/disk6"
    ];
  };

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
