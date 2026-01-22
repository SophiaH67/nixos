{
  config,
  lib,
  self,
  ...
}:
let
  mkIpPart = str: builtins.substring 0 4 (builtins.hashString "sha1" str);
  mkIp = str: "fd31:a15a::${mkIpPart str}";
  mkBracketedIp = str: "[${mkIp str}]";
  peers =
    let
      islaEnabled = builtins.filter (name: self.nixosConfigurations.${name}.config.sophices.isla.enable) (
        builtins.attrNames self.nixosConfigurations
      );
    in
    map (name: self.nixosConfigurations.${name}.config.networking.hostName) islaEnabled;
  filteredPeers = builtins.filter (h: h != config.networking.hostName) peers;
in
{
  options.sophices.isla.enable = lib.mkOption {
    type = lib.types.bool;
    default = builtins.pathExists ../../../secrets/isla-${config.networking.hostName}-wgpriv.age;
    description = "Enable Isla. Defaults to yes if a private key was found for this host";
  };

  config = lib.mkIf config.sophices.isla.enable {
    age.secrets."isla-${config.networking.hostName}-wgpriv" = {
      file = ../../../secrets/isla-${config.networking.hostName}-wgpriv.age;
      mode = "444";
    };

    networking.firewall.allowedUDPPorts = [ config.networking.wireguard.interfaces.isla0.listenPort ];
    networking.firewall.interfaces.isla0 = {
      allowedTCPPorts =
        [ ]
        ++ config.services.openssh.ports
        ++ lib.optional config.services.prometheus.exporters.node.enable config.services.prometheus.exporters.node.port;
    };
    services.fail2ban.ignoreIP = map mkIp peers;

    networking.wireguard = {
      enable = true;
      interfaces.isla0 = {
        listenPort = 51110; # aira
        ips = [
          (mkIp config.networking.hostName)
        ];
        privateKeyFile = config.age.secrets."isla-${config.networking.hostName}-wgpriv".path;
        peers = map (peer: {
          name = peer;
          allowedIPs = [
            (mkIp peer)
          ];
          publicKey = builtins.readFile ../../../secrets/isla-${peer}-wgpub;

          endpoint =
            let
              domainConfig = self.nixosConfigurations.${peer}.config.networking.domain or null;
              domain = if domainConfig == null then "dev.sophiah.gay" else domainConfig;
            in
            "${peer}.${domain}:${toString config.networking.wireguard.interfaces.isla0.listenPort}";
        }) filteredPeers;
      };
    };

    services.unbound.settings = {
      local-zone = ''"isla." static'';
    };
    services.unbound.settings.local-data = map (peer: ''"${peer}.isla. AAAA ${mkIp peer}"'') peers;

    users.groups.isla-sshable = { };

    services.prometheus.exporters = {
      node = {
        enable = true;
        enabledCollectors = [ "systemd" ];
        port = 51120;
        listenAddress = mkBracketedIp config.networking.hostName;
      };
    };
  };
}
