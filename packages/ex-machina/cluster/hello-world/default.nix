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
      name = "hello-world";

      passthru.kubernetes.objects = config.kubernetes.objects;
    };

    kubernetes = {
      namespace = name;
      resources.namespaces.${name} = { };

      resources.services.nginx.spec = {
        ports = [
          {
            name = "http";
            port = 80;
          }
        ];
        selector.app = "nginx";
      };

      resources.deployments.nginx.spec = {
        replicas = 10;
        selector.matchLabels.app = "nginx";
        template = {
          metadata.labels.app = "nginx";
          spec = {
            containers.nginx = {
              image = "rancher/hello-world";
              imagePullPolicy = "IfNotPresent";
            };
          };
        };
      };
    };
  };
}
