{ lib, pkgs, config, ...}:
{
  networking.hostName = "ayumu";
  networking.domain = "dev.sophiah.gay";

  environment.systemPackages = [ pkgs.spotify ];

  sophices.tailscale.enable = true;
  soph.drawing.enable = true;
}
