{
  config,
  lib,
  ...
}:
let
  mkIpPart = str: builtins.substring 0 4 (builtins.hashString "sha1" str);
  mkIp = str: "fd31:a15a::${mkIpPart str}";
  peers = [
    "rikka"
    "kiara"
  ];
  filteredPeers = builtins.filter (h: h != config.networking.hostName) peers;
in
{
  options.sophices.isla.enable = lib.mkEnableOption "Isla";

  config = lib.mkIf config.sophices.isla.enable {
    age.secrets."isla-${config.networking.hostName}-wgpriv" = {
      file = ../../../secrets/isla-${config.networking.hostName}-wgpriv.age;
      mode = "444";
    };
    
    networking.firewall.trustedInterfaces = [ "isla0" ];

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
          endpoint = "${peer}.dev.sophiah.gay:${toString config.networking.wireguard.interfaces.isla0.listenPort}";
        }) filteredPeers;
      };
    };
  };
}
