{ inputs, ... }:
{
  containers.prometheus = {
    autoStart = true;
    privateNetwork = true;

    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::7";

    bindMounts = {
      "/var/lib/prometheus2" = {
        hostPath = "/Fuwawa/appdata/prometheus";
        isReadOnly = false;
      };
    };

    ephemeral = true;

    config =
      {
        lib,
        config,
        ...
      }:
      {
        services.prometheus = {
          enable = true;
        };

        networking = {
          firewall.allowedTCPPorts = [ 9090 ];

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;

        system.stateVersion = "26.05";
      };
  };
}
