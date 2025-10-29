{ lib, pkgs, config, ...}:
{
  networking.hostName = "ayumu";
  networking.domain = "dev.sophiah.gay";

  environment.systemPackages = [ pkgs.spotify ];

  sophices.tailscale.enable = true;
  sophices.boot-unlock.enable = true;
  soph.drawing.enable = true;

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };
}
