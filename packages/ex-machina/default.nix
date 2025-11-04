{ inputs, system, ... }:
  inputs.kubenix.packages.${system}.default.override {
    module = import ./cluster;
    specialArgs = { inherit inputs; };
  }