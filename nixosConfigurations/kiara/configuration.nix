{ lib, ... }:
{
  networking.hostName = "kiara";
  networking.domain = "dev.sophiah.gay";

  home-manager.users.sophia = {
    sophrams.atuin.enable = lib.mkForce false;
  };

  sophices.skeb-scraper.enable = true;

  services.plex = {
    enable = true;
    openFirewall = true;
  };
}
