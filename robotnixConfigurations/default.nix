{ inputs, ... }:
{
  yukihana-lamy = inputs.robotnix.lib.robotnixSystem ./yukihana-lamy/configuration.nix;
  uruha-rushia = inputs.robotnix.lib.robotnixSystem ./uruha-rushia/configuration.nix;
}
