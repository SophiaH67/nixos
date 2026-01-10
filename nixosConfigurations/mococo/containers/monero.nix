{
  networking.firewall.allowedTCPPorts = [ 18080 18081 ];

  containers.monero = {
    autoStart = true;
    privateNetwork = true;

    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::9";

    bindMounts = {
      "/data" = {
        hostPath = "/Fuwawa/appdata/monero";
        isReadOnly = false;
      };
    };

    forwardPorts = [
      {
        containerPort = 18080;
        hostPort = 18080;
        protocol = "tcp";
      }
      {
        containerPort = 18081;
        hostPort = 18081;
        protocol = "tcp";
      }
    ];

    ephemeral = true;

    config =
      {
        lib,
        ...
      }:
      {
        services.monero = {
          enable = true;
          dataDir = "/data";

          limits = {
            download = 32768;
            upload = 8192;
          };

          prune = true;

          priorityNodes = [
            "xmr-in-berlin.boldsuck.org:18080"
            "xmr-de.boldsuck.org:18080"
          ];

          # Stupid nixos module is so horrible
          rpc.port = 9999;

          extraConfig = ''
            out-peers=12
            in-peers=48
            disable-rpc-ban=1

            p2p-bind-port=18080
            p2p-bind-ipv6-address=[::] 
            p2p-use-ipv6=1
            p2p-ignore-ipv4=1

            rpc-restricted-bind-ipv6-address=[::]
            rpc-restricted-bind-port=18081
            rpc-use-ipv6=1
            rpc-ignore-ipv4=1
          '';
        };

        networking = {
          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;

        system.stateVersion = "26.05";
      };
  };
}
