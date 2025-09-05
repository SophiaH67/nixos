{
  environment.etc."tailscale/auth.key".source = ./secrets/auth.key;
    services.tailscale = {
    enable = true;
    useRoutingFeatures = "both"; # optional: allow subnet exit routing
    openFirewall = true;
    authKeyFile = "/etc/tailscale/auth.key";
    disableTaildrop = true;
    interfaceName = "tailscale0";
  };
  systemd.services.tailscaled.enable = true;
}