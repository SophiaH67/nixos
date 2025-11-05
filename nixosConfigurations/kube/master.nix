{ pkgs, lib, config, self, ... }:
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
      default = (builtins.elemAt config.networking.interfaces.br0.ipv6.addresses 0).address;
    };
  };

  config = lib.mkIf cfg.enable {
    networking.bridges = {
      "br0" = {
        interfaces = [ "enp3s0" ];
      };
    };

    networking.firewall.enable = lib.mkForce false;

    networking.nameservers = [ "2a01:4f8:c2c:123f::1" ];
    services.resolved.dnssec = lib.mkForce "false";
    services.resolved.dnsovertls = lib.mkForce "false";

    virtualisation.containerd.enable = true;
    # Longhorn - https://github.com/longhorn/longhorn/issues/2166#issuecomment-2994323945
    services.openiscsi = {
      enable = true;
      name = "${config.networking.hostName}-initiatorhost";
    };
    systemd.services.iscsid.serviceConfig = {
      PrivateMounts = "yes";
      BindPaths = "/run/current-system/sw/bin:/bin";
    };
    
    environment.systemPackages = [ pkgs.nfs-utils pkgs.cryptsetup ];

    systemd.tmpfiles.rules = [
      # Symlink CNI plugins into /opt/cni/bin, as containerd expects to find it there.
      # This is needed for flannel to work correctly.
      "L+ /opt/cni/bin/loopback - - - - ${pkgs.cni-plugins}/bin/loopback"
      "L+ /opt/cni/bin/bridge - - - - ${pkgs.cni-plugins}/bin/bridge"
      "L+ /opt/cni/bin/host-local - - - - ${pkgs.cni-plugins}/bin/host-local"
      "L+ /opt/cni/bin/portmap - - - - ${pkgs.cni-plugins}/bin/portmap"
      "L+ /opt/cni/bin/macvlan - - - - ${pkgs.cni-plugins}/bin/macvlan"

      # https://github.com/longhorn/longhorn/issues/2166#issuecomment-1740179416
      "L+ /usr/local/bin - - - - /run/current-system/sw/bin/"
    ];

    age.secrets.kube-longhorn.file = ../../secrets/kube-longhorn.age;
    age.secrets.kube-forgejo-registration-secret.file = ../../secrets/kube-forgejo-registration-secret.age;

    services.k3s = {
      role = "server";
      gracefulNodeShutdown.enable = true;
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
        # Kubenix
        kubenix = {
          content = self.packages.x86_64-linux.ex-machina-kube-nix.config.kubernetes.resultYAML;
          enable = true;
        };
        # CNI
        kube-vip-rbac = {
          source = ./manifests/kube-vip.yaml;
          enable = true;
        };
        flannel = {
          source = ./manifests/kube-flannel.yml;
          enable = true;
        };
        longhorn-secret = {
          source = config.age.secrets.kube-longhorn.path;
          enable = true;
        };
        # kube-virt
        kubevirt-cr = {
          source = ./manifests/kube-virt/kubevirt-cr.yaml;
          enable = true;
        };
        kubevirt-operator = {
          source = ./manifests/kube-virt/kubevirt-operator.yaml;
          enable = true;
        };
        kubevirt-webui = {
          source = ./manifests/kube-virt/kubevirt-webui.yaml;
          enable = true;
        };
        # Cloud-native PG
        cnpg = {
          source = ./manifests/cnpg.yaml;
          enable = true;
        };
        # Soph
        ## Conduwuit
        conduwuit = {
          source = ./manifests/soph/conduwuit.yaml;
          enable = true;
        };
        ## Forgejo Runner
        forgejo-runner-secret = {
          source = config.age.secrets.kube-forgejo-registration-secret.path;
          enable = true;
        };
        forgejo-runner = {
          source = ./manifests/soph/forgejo-runner.yaml;
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
