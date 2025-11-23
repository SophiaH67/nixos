{
  config,
  kubenix,
  lib,
  name,
  args,
  ...
}:
{
  submodules.instances.hello-world = {
    submodule = "namespaced";

    args.kubernetes = {
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
