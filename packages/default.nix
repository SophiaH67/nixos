
{ nixpkgs, ... }@inputs:
let
  systems = [ "x86_64-linux" "aarch64-linux" ];

  forAllSystems = f: builtins.listToAttrs (map (system: {
    name = system;
    value = f system;
  }) systems);
in forAllSystems (system:
  let
    pkgs = import nixpkgs { inherit system; };
    exMachina = import ./ex-machina { inherit inputs pkgs system; };
  in
  {
    ex-machina = exMachina;
  }
)