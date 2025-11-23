{ kubenix, ... }:
{
  imports = [
    kubenix.modules.k8s
    kubenix.modules.helm
    kubenix.modules.submodules

    ./hello-world
    ./longhorn.nix
  ];

  submodules.imports = [  ./lib/namespaced.nix ];

  kubenix.project = "ex-machina";
  kubernetes.version = "1.26";
  kubernetes.resources.pods.example.spec.containers.nginx.image = "nginx";
}