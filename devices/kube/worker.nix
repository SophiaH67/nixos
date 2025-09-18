# nix-build '<nixpkgs/nixos>' -A vm -I nixpkgs=channel:nixos-unstable -I nixos-config=./devices/kube/worker.nix -o worker
{ config, pkgs, ... }:

{
  imports = [ ./common.nix ];

  services.k3s.role = "agent";

  # Point worker to master API server
  services.k3s.serverAddr = "https://2a02:810d:6f83:ad00:3ac1::67:6443";

  environment.etc."k3s-join-key".source = ./secrets/join.key;

  # Once master is up, generate a join key via `k3s token create` and place it in `secrets/join.key`
  #TODO: Maybe we can automate this with ssh keys?
  services.k3s.tokenFile = "/etc/k3s-join-key";
}