{ nixpkgs, ... }@inputs:
let
  systems = [
    "x86_64-linux"
    "aarch64-linux"
  ];

  forAllSystems =
    f:
    builtins.listToAttrs (
      map (system: {
        name = system;
        value = f system;
      }) systems
    );
in
forAllSystems (
  system:
  let
    pkgs = import nixpkgs { inherit system; };
  in
  {
    thirtyninec3-font = import ./thirtyninec3-font { inherit pkgs; };
    ex-machina = import ./ex-machina { inherit inputs pkgs system; };
    ex-machina-kube-nix = import ./ex-machina/kubenix.nix { inherit inputs pkgs system; };
    soph-vr-mode = import ./soph-vr-mode {
      inherit inputs pkgs;
      lib = pkgs.lib;
    };
  }
)
