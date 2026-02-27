{ lib, ... }:
{
  imports = [ ../yukihana-lamy/configuration.nix ];

  device = lib.mkForce "panther";
}
