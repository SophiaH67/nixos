{ kubenix, ... }:
{
  imports = [
    kubenix.modules.k8s
    kubenix.modules.helm
    ./longhorn.nix
  ];
  
  kubernetes.resources.pods.example.spec.containers.nginx.image = "nginx";
}