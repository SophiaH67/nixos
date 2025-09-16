{ pkgs, lib, config, ... }:
with lib;
let
  cfg = config.services.ex-machina;
in {
  imports = [ ./common.nix ];

  options.services.ex-machina = {
    enable = mkEnableOption "ex-machina";

    init = mkOption {
      type = types.bool;
      default = false;
      description = "Whether this build will initialise the cluster.";
    };

    initialMasterIp = mkOption {
      type = types.str;
      description = "The IP address of the initial master node to join. Only used if init is false.";
      example = "2a02:810d:6f83:ad00:1ac0:4dff:fed9:df52";
    };
  };

  config = mkIf cfg.enable {
    services.k3s.role = "server";
    services.keepalived = {
      enable = true;
      vrrpInstances.k3s = {
        interface = "eth0";
        virtualIps = [{
          addr = "2a02:810d:6f83:ad00:3ac1::67";
          }]; 
        virtualRouterId = 67;
        priority = if cfg.init then 200 else 100;
        state = if cfg.init then "MASTER" else "BACKUP";
      };
    };

    services.k3s.extraFlags = toString ([
      "--disable traefik"
      "--node-taint node-role.kubernetes.io/master=true:NoSchedule"
      
      
    ] ++ optionals cfg.init [ "--cluster-init" ] ++ optionals (!cfg.init && !empty(cfg.initialMasterIp)) [ "--server https://${cfg.initialMasterIp}:6443" ]);

    services.k3s.clusterInit = true; # HA etcd
  };
}
