{ lib, ... }:
{
  virtualisation.vmVariant.virtualisation.memorySize = lib.mkForce 256;

  nixpkgs.config.allowUnsupportedSystem = true;
}
