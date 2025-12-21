{
  config,
  lib,
  ...
}:
{
  options.sophices.skeb-scraper.enable = lib.mkEnableOption "Soph Skeb Scraper";

  config = lib.mkIf config.sophices.skeb-scraper.enable {
    age.secrets."skeb-scraper.env".file = ../../../secrets/skeb-scraper.env.age;

    virtualisation.oci-containers.containers.scraper = {
      image = "xn--55q89qy6p.com/soph/sophs-skeb/scraper:latest";
      environmentFiles = [
        config.age.secrets."skeb-scraper.env".path
      ];
    };

    sophices.tailscale.enable = true;
  };
}
