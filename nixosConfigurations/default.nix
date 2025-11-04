
{ nixpkgs, home-manager, agenix, disko, nixos-generators, nixos-hardware, ... }@inputs:
let
  baseModules = [
    ../common/base.nix
    ../common/sophia.nix
    ../nixosModules
    home-manager.nixosModules.home-manager
    agenix.nixosModules.default
  ];

  devModules = [
    ../common/sophia-dev.nix
    ../common/sophia-gui.nix
    ../common/apps/gaming.nix
    {
      environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
    }
  ] ++ baseModules;

  deployableModules = [
    ../common/forgejo.nix
    disko.nixosModules.disko
    ../common/vm-able.nix
  ] ++ baseModules;

  exMachinaModules = [
    ../devices/kube/nodes/hardware-configuration.nix
    ../devices/kube/nodes/disko.nix
  ] ++ deployableModules;

  vmModules = [
    ../common/base-vm.nix
    nixos-generators.nixosModules.all-formats
  ] ++ deployableModules;
in {
  rikka = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/rikka/configuration.nix
      ../devices/rikka/hardware-configuration.nix
    ] ++ devModules;
  };

  ayumu = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/ayumu/configuration.nix
      ../devices/ayumu/hardware-configuration.nix
      ../common/apps/vr.nix
    ] ++ devModules;
  };

  alice = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/alice/configuration.nix
      ../devices/alice/hardware-configuration.nix
    ] ++ devModules;
  };

  yuuna = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "aarch64-linux";
    modules = [
      ../devices/yuuna/configuration.nix
      ../devices/yuuna/hardware-configuration.nix
      nixos-hardware.nixosModules.raspberry-pi-4
    ] ++ deployableModules;
  };

  moshimoshi = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/moshimoshi/configuration.nix
      ../devices/moshimoshi/hardware-configuration.nix
    ] ++ vmModules;
  };

  inanis = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/inanis/configuration.nix
    ] ++ vmModules;
  };

  schwi = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/kube/nodes/schwi.nix
    ] ++ exMachinaModules;
  };

  emir-eins = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/kube/nodes/emir-eins.nix
    ]  ++ exMachinaModules;
  };

  emir-zwei = nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    system = "x86_64-linux";
    modules = [
      ../devices/kube/nodes/emir-zwei.nix
    ]  ++ exMachinaModules;
  };
}