{ lib, pkgs, config, ...}:
{
  networking.hostName = "ayumu";
  networking.domain = "dev.sophiah.gay";

  environment.systemPackages = [ pkgs.spotify ];

  hardware.opentabletdriver.enable = true;
}
