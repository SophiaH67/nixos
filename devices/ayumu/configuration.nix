{ lib, pkgs, config, ...}:
{
  networking.hostName = "ayumu";
  networking.domain = "dev.sophiah.gay";

  environment.systemPackages = [ pkgs.spotify ];

  sophices.tailscale.enable = true;
  sophices.boot-unlock.enable = false;
  sophices.boot-unlock.tor = true;
  soph.drawing.enable = true;

  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "sophia";

  services.sunshine = {
    enable = true;
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
  };

  sophices.plymouth.enable = true;
  sophices.builder-user.enable = true;
}
