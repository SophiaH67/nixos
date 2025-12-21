{ lib, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
  ];

  boot.initrd.availableKernelModules = [
    "xhci_pci"
    "virtio_pci"
    "virtio_scsi"
    "usbhid"
    "sr_mod"
    "virtio_blk"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "aarch64-linux";

  networking = {
    usePredictableInterfaceNames = false;
    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "152.53.209.71";
          prefixLength = 22;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a0a:4cc0:2000:c793:e43c:fdff:fec1:bb60";
          prefixLength = 64;
        }
      ];
    };

    defaultGateway = {
      address = "152.53.208.1";
      interface = "eth0";
    };

    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
  };
}
