{ inputs, system, ... }@args:
inputs.kubenix.packages.${system}.default.override {
  module = import ./cluster;
  specialArgs = args;
}
