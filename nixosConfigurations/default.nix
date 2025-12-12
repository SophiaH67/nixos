{ inputs, ... }@args:
let
  inherit (inputs)
    nixpkgs
    home-manager
    agenix
    disko
    nixos-generators
    nixos-hardware
    ;
  baseModules = [
    { soph.base.enable = true; }
    ../nixosModules
    home-manager.nixosModules.home-manager
    agenix.nixosModules.default
  ];

  devModules = [
    ../common/sophia-gui.nix
    ../common/apps/gaming.nix
    {
      environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
    }
  ]
  ++ baseModules;

  deployableModules = [
    ../common/forgejo.nix
    disko.nixosModules.disko
    ../common/vm-able.nix
  ]
  ++ baseModules;

  exMachinaModules = [
    ./kube/nodes/hardware-configuration.nix
    ./kube/nodes/disko.nix
    ../common/alice.nix
  ]
  ++ deployableModules;

  vmModules = [
    { soph.base-vm.enable = true; }
    nixos-generators.nixosModules.all-formats
  ]
  ++ deployableModules;
in
{
  rikka = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./rikka/configuration.nix
      ./rikka/hardware-configuration.nix
    ]
    ++ devModules;
  };

  ayumu = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./ayumu/configuration.nix
      ./ayumu/hardware-configuration.nix
      ../common/apps/vr.nix
    ]
    ++ devModules;
  };

  alice = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./alice/configuration.nix
      ./alice/hardware-configuration.nix
    ]
    ++ devModules;
  };

  yuuna = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "aarch64-linux";
    modules = [
      ./yuuna/configuration.nix
      ./yuuna/hardware-configuration.nix
      nixos-hardware.nixosModules.raspberry-pi-4
    ]
    ++ deployableModules;
  };

  moshimoshi = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./moshimoshi/configuration.nix
      ./moshimoshi/hardware-configuration.nix
    ]
    ++ vmModules;
  };

  inanis = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./inanis/configuration.nix
    ]
    ++ vmModules;
  };

  schwi = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./kube/nodes/schwi.nix
    ]
    ++ exMachinaModules;
  };

  emir-eins = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./kube/nodes/emir-eins.nix
    ]
    ++ exMachinaModules;
  };

  emir-zwei = nixpkgs.lib.nixosSystem {
    specialArgs = args;
    system = "x86_64-linux";
    modules = [
      ./kube/nodes/emir-zwei.nix
    ]
    ++ exMachinaModules;
  };
}
