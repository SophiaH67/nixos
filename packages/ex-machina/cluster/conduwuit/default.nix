{
  config,
  kubenix,
  lib,
  name,
  args,
  ...
}:
{
  imports = with kubenix.modules; [
    submodule
    k8s
  ];

  config = {
    submodule = {
      name = "conduwuit";

      passthru.kubernetes.objects = config.kubernetes.objects;
    };

    kubernetes = {
      namespace = name;
      resources.namespaces.${name} = { };

      resources.persistentVolumeClaims.conduwuit-pvc.spec = {
        accessModes = [ "ReadWriteOnce" ];
        resources.requests.storage = "4Gi";
      };

      resources.configMaps.caddy-config.data."Caddyfile" = builtins.readFile ./Caddyfile;

      resources.services.conduwuit-service = {
        metadata.annotations."kube-vip.io/loadbalancerIPs" = "2a02:810d:6f83:ad00:acab::fafa";
        spec = {
          type = "LoadBalancer";
          selector.app = "conduwuit";
          ports = [
            {
              protocol = "TCP";
              port = 80;
              targetPort = 80;
              name = "http";
            }
            {
              protocol = "TCP";
              port = 443;
              targetPort = 443;
              name = "https";
            }
          ];
        };
      };

      resources.deployments.conduwuit-deployment.spec = {
        replicas = 1;
        strategy.type = "Recreate";
        selector.matchLabels.app = "conduwuit";
        template = {
          metadata.labels.app = "conduwuit";
          spec = {
            containers = {
              conduwuit = {
                image = "xn--55q89qy6p.com/soph/tuwunel-logging:v1.4.2";
                volumeMounts."/var/lib/conduwuit".name = "conduwuit-volume";

                env = {
                  CONDUWUIT_SERVER_NAME.value = "cat.sophiah.gay";
                  CONDUWUIT_DATABASE_PATH.value = "/var/lib/conduwuit";
                  CONDUWUIT_PORT.value = "6167";
                  CONDUWUIT_MAX_REQUEST_SIZE.value = "200000000";
                  CONDUWUIT_ALLOW_REGISTRATION.value = "false";
                  CONDUWUIT_REGISTRATION_TOKEN.value = "GtpePKmUEpfgRGjvx9S98bJoHGLUuBrUgv7MUcMRtxdtwkeAPNm7ihAPCXm4ggXVS6LG9jzaczTt9fpRVCdmxRvepZUyRr5Rk26exu83PkGv7FRTqKnaW7VcUUQdo44q";
                  CONDUWUIT_ALLOW_FEDERATION.value = "true";
                  CONDUWUIT_ALLOW_CHECK_FOR_UPDATES.value = "true";
                  CONDUWUIT_TRUSTED_SERVERS.value = ''["matrix.org]'';
                  CONDUWUIT_ADDRESS.value = "[::]";
                  TUWUNEL_IP_LOOKUP_STRATEGY.value = "2";
                };
              };

              caddy-sidecar = {
                image = "docker.io/caddy:2.10.2";
                volumeMounts."/etc/caddy/Cadyfile" = {
                  subPath = "Caddyfile";
                  name = "caddy-config";
                };
                volumeMounts."/data" = {
                  subPath = "caddy";
                  name = "conduwuit-volume";
                };
              };
            };
            volumes = {
              conduwuit-volume.persistentVolumeClaim.claimName = "conduwuit-pvc";
              caddy-config.configMap.name = "caddy-config";
            };
          };
        };
      };
    };
  };
}
