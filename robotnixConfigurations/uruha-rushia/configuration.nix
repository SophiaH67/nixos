let
  lamy = import ../yukihana-lamy/configuration.nix;
in
lamy
// {
  device = "panther";
}
