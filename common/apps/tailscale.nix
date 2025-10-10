{
  age.secrets.tailscale-device.file = ../../secrets/tailscale-device.age;
  services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # optional: allow subnet exit routing
    openFirewall = true;
    authKeyFile = config.age.secrets.tailscale-device.path;
    disableTaildrop = true;
    interfaceName = "tailscale0";
  };
  systemd.services.tailscaled.enable = true;
}