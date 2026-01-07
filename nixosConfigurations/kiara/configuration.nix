{ lib, pkgs, ... }:
let
  mkForward = port: {
    description = "Forward traffic from IPv4 to IPv6";
    wantedBy = [ "multi-user.target" ];
    after = [ "network.target" ];
    script =
      let
        listenIPv4 = "152.53.209.71";
        targetIPv6 = "[2a02:810d:6f83:ad00::acab]";
      in
      "${pkgs.socat}/bin/socat TCP4-LISTEN:${toString port},bind=${listenIPv4},reuseaddr,fork TCP6:${targetIPv6}:${toString port}";
    serviceConfig = {
      User = "nobody";
      Group = "nogroup";
      AmbientCapabilities = [ "CAP_NET_BIND_SERVICE" ];
      Restart = "always";
      RestartSec = 5;
    };
  };
in
{
  networking.hostName = "kiara";
  networking.domain = "dev.sophiah.gay";

  home-manager.users.sophia = {
    sophrams.atuin.enable = lib.mkForce false;
  };

  sophices.skeb-scraper.enable = true;
  services.openssh.listenAddresses = [
    {
      addr = "[::]";
      port = 22;
    }
  ];

  systemd.services.forward-22 = mkForward 22;
  systemd.services.forward-80 = mkForward 80;
  systemd.services.forward-443 = mkForward 443;

  networking.firewall.allowedTCPPorts = [
    22
    80
    443
  ];
}
