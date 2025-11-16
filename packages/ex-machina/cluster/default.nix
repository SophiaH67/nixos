{ kubenix, ... }:
{
  imports = [
    kubenix.modules.k8s
    kubenix.modules.helm
    kubenix.modules.submodules

    ./longhorn.nix
  ];

  submodules.imports = [
    ./conduwuit
    ./hello-world
    ];

  submodules.instances.blahblah = {
    submodule = "hello-world";
  };

  submodules.instances.conduwuit-namespace.submodule = "conduwuit";

  kubenix.project = "ex-machina";
  kubernetes.version = "1.26";
  kubernetes.resources.pods.example.spec.containers.nginx.image = "nginx";
}