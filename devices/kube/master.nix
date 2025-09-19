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
      default = "2a02:810d:6f83:ad00:3ac1::67";
    };
  };

  config = lib.mkIf cfg.enable {
    services.keepalived = {
      enable = true;
      vrrpInstances.k3s = {
        interface = "enp3s0";
        virtualIps = [{
          addr = cfg.virtualIp;
          }]; 
        virtualRouterId = 67;
        priority = if cfg.init then 200 else 100;
        state = if cfg.init then "MASTER" else "BACKUP";
      };
    };

    networking.firewall.allowedTCPPorts = [ 6443 6444 2379 2380 10250 10251 10252 ];

    services.k3s = {
      role = "server";
      extraFlags = "--disable traefik --debug --tls-san 2a02:810d:6f83:ad00:3ac1::67";
      enable = true;
    } // (if cfg.init then {
      clusterInit = true;
    } else {
      # serverAddr = "https://${cfg.virtualIp}:6443";
      serverAddr = "https://[2a02:810d:6f83:ad00:acab::1]:6443";
    });
  };
}
