{
  config,
  lib,
  ...
}:
{
  options.sophices.tailscale.enable = lib.mkEnableOption "Soph Tailscale";

  config = lib.mkIf config.sophices.tailscale.enable {
    age.secrets.tailscale-device.file = ../../../secrets/tailscale-device.age;
    services.tailscale = {
      enable = true;
      openFirewall = true;
      useRoutingFeatures = "both"; # optional: allow subnet exit routing
      authKeyFile = config.age.secrets.tailscale-device.path;
      interfaceName = "tailscale0";
      extraSetFlags = [
        "--accept-dns=false"
      ];
    };
    networking.search = [ "neko-hammerhead.ts.net" ];
    networking.nameservers = [ "100.100.100.100" ];
    networking.hosts."100.76.186.121" = [ "r4birth" ];
    systemd.services.tailscaled.enable = true;
  };
}
