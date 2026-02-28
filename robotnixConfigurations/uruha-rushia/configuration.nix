{ lib, ... }:
{
  imports = [ ../yukihana-lamy/configuration.nix ];

  device = lib.mkForce "panther";
  bootanimation.logoMask = lib.mkForce ./bootmask.png;
  bootanimation.logoShine = lib.mkForce ./bootshine.png;
}
