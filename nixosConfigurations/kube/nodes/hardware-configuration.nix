{ lib, ... }:
{
  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

  networking.useDHCP = false;
  networking.dhcpcd.enable = false;

  networking = {
    defaultGateway6 = {
      address = "fe80::62b5:8dff:fe35:2b08";
      interface = "br0";
    };
    defaultGateway = {
      address = "192.168.178.1";
      interface = "br0";
    };
  };
}
