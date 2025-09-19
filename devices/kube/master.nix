{ pkgs, lib, config, ... }:
let
  cfg = config.services.ex-machina;
in {
  # imports = [ ./common.nix ];

  options.services.ex-machina = {
    enable = lib.mkEnableOption "ex-machina";

    init = lib.mkOption {
      type = lib.types.bool;
      default = false;
      description = "Whether this build will initialise the cluster.";
    };

    virtualIp = lib.mkOption {
      type = lib.types.str;
      description = "The IP address of the initial master node to join. Only used if init is false.";
      default = "2a02:810d:6f83:ad00:acab::67";
    };

    nodeIp = lib.mkOption {
      type = lib.types.str;
      description = "The IP address of this node.";
      default = (builtins.elemAt config.networking.interfaces.enp3s0.ipv6.addresses 0).address;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.firewall.allowedTCPPorts = [ 6443 6444 2379 2380 10250 10251 10252 ];

    services.k3s = {
      role = "server";
      extraFlags = "--disable traefik --tls-san ${cfg.virtualIp} --node-ip ${cfg.nodeIp} --node-external-ip ${cfg.nodeIp}";
      enable = true;
      manifests = {
        kube-vip-rbac = {
          source = ./manifests/kube-vip.yaml;
          enable = true;
        };
      };
    } // (if cfg.init then {
      clusterInit = true;
    } else {
      serverAddr = "https://${cfg.virtualIp}:6443";
      # serverAddr = "https://[2a02:810d:6f83:ad00:acab::1]:6443";
    });
  };
}
