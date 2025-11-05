{ inputs, system, ... }@args:
  inputs.kubenix.evalModules.${system} {
    module = ./cluster;
    specialArgs = args;
  }