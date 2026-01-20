{
  pkgs,
  lib,
  config,
  ...
}:
let
  cfg = config.services.ex-machina;
in
{
  imports = [ ./common.nix ];

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

    users.mutableUsers = false;

    environment.systemPackages = [
      pkgs.cryptsetup
    ];
  };
}
