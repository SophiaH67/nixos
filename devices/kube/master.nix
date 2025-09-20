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

    virtualisation.containerd.enable = true;
    # Longhorn dependencies
    services.openiscsi.enable = true;
    environment.systemPackages = [ pkgs.nfs-utils ];

    # Symlink the loopback plugin into /opt/cni/bin, as containerd expects to find it there.
    # This is needed for flannel to work correctly.
    systemd.tmpfiles.rules = [
      "L+ /opt/cni/bin/loopback - - - - ${pkgs.cni-plugins}/bin/loopback"
      # Same with bridge plugin
      "L+ /opt/cni/bin/bridge - - - - ${pkgs.cni-plugins}/bin/bridge"
      # And host-local IPAM plugin
      "L+ /opt/cni/bin/host-local - - - - ${pkgs.cni-plugins}/bin/host-local"
      # portmap
      "L+ /opt/cni/bin/portmap - - - - ${pkgs.cni-plugins}/bin/portmap"
    ];

    services.k3s = {
      role = "server";
      extraFlags = [
        "--disable traefik"
        "--flannel-backend none"
        "--tls-san ${cfg.virtualIp}"
        "--node-ip ${cfg.nodeIp}"
        "--node-external-ip ${cfg.nodeIp}"
        "--cluster-cidr=fd00:3ac1::/56"
        # Specify a pod CIDR to ensure flannel uses it
        "--kube-controller-manager-arg=allocate-node-cidrs=true"
        "--kube-controller-manager-arg=cluster-cidr=fd00:3ac1::/56"
        "--kube-controller-manager-arg=node-cidr-mask-size-ipv6=64"
      ];
      enable = true;
      token = "exmachinampXeJcPsGKDFgapj";
      manifests = {
        kube-vip-rbac = {
          source = ./manifests/kube-vip.yaml;
          enable = true;
        };
        flannel = {
          source = ./manifests/kube-flannel.yml;
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
