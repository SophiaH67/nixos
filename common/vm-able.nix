{ config, lib, ... }:
let
  v = {
    virtualisation.diskSize = 10240;
    virtualisation.tpm.enable = true;
    disko.devices.disk.main.device = lib.mkForce "/dev/vda";
    environment.etc."is-vm".text = "Mhm";
  };
in
{
  virtualisation.vmVariant = v;

  virtualisation.vmVariantWithDisko = v;
}
