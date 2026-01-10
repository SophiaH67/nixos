{ inputs, config, ... }:
{
  networking.firewall.extraInputRules = ''
    ip6 saddr ${config.containers.prometheus.localAddress6} tcp dport { 18081, 18082 } accept
  '';

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
        pkgs,
        ...
      }:
      {
        imports = [ inputs.agenix.nixosModules.default ];

        age.identityPaths = [ "/var/lib/prometheus2/id_ed25519" ];

        age.secrets."prometheus-oath2keyfile" = {
          file = ../../../secrets/prometheus-oath2keyfile.age;
          mode = "444";
        };

        services.prometheus = {
          enable = true;

          scrapeConfigs = [
            {
              job_name = "immich_api";
              scrape_interval = "15s";
              static_configs = [
                {
                  targets = [ "[fc00::1]:18081" ];
                }
              ];
            }
            {
              job_name = "immich_microservices";
              scrape_interval = "15s";
              static_configs = [
                {
                  targets = [ "[fc00::1]:18081" ];
                }
              ];
            }
          ];
        };

        services.oauth2-proxy = {
          enable = true;
          reverseProxy = true;
          provider = "oidc";
          loginURL = "https://xn--15qt0w.xn--55q89qy6p.com/authorize";
          clientID = "49755caf-2105-4e02-b4b3-73208447522f";
          oidcIssuerUrl = "https://xn--15qt0w.xn--55q89qy6p.com";
          keyFile = config.age.secrets."prometheus-oath2keyfile".path;
          httpAddress = "http://[::]:4180";
          email.domains = [ "*" ];
          upstream = [
            "http://[::1]:9090"
          ];
        };

        # It really loves to just start before working network... This is scuffed but it'll work
        systemd.services."oauth2-proxy".serviceConfig.ExecStartPre = [ "${pkgs.toybox}/bin/sleep 5" ];

        networking = {
          firewall.allowedTCPPorts = [
            4180
            9090 # Expose for use in grafana. In the future, maybe we can be more strict
          ];

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;

        system.stateVersion = "26.05";
      };
  };
}
