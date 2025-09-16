{ config, lib, ...} :
{
  virtualisation.vmVariant = {
    virtualisation.diskSize = 10240;
    disko.devices.disk.main.device = "/dev/vda";
    environment.etc."is-vm".text = "Mhm";
  };
}
