{
  config,
  lib,
  pkgs,
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
    };
    systemd.services.tailscaled.enable = true;
  };
}
