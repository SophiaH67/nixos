{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-generators = {
      url = "github:nix-community/nixos-generators";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    deploy-rs.url = "github:serokell/deploy-rs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, deploy-rs, disko, nixos-generators, agenix, nixos-hardware, nixpkgs-xr, ... }@inputs: {
    baseModules = [
      ./common/base.nix
      ./common/sophia.nix
      ./nixosModules
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
    ];

    devModules = [
      ./common/sophia-dev.nix
      ./common/sophia-gui.nix
      ./common/apps/gaming.nix
      {
        environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
      }
    ] ++ self.baseModules;

    deployableModules = [
      ./common/forgejo.nix
      disko.nixosModules.disko
      ./common/vm-able.nix
    ] ++ self.baseModules;

    exMachinaModules = [
      ./devices/kube/nodes/hardware-configuration.nix
      ./devices/kube/nodes/disko.nix
    ] ++ self.deployableModules;

    vmModules = [
      ./common/base-vm.nix
    ] ++ self.deployableModules;

    nixosConfigurations = {
      rikka = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/rikka/configuration.nix
          ./devices/rikka/hardware-configuration.nix
          lanzaboote.nixosModules.lanzaboote
        ] ++ self.devModules;
      };

      ayumu = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/ayumu/configuration.nix
          ./devices/ayumu/hardware-configuration.nix
          ./common/apps/vr.nix
          ./common/apps/tailscale.nix
          nixpkgs-xr.nixosModules.nixpkgs-xr
          lanzaboote.nixosModules.lanzaboote
        ] ++ self.devModules;
      };

      alice = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/alice/configuration.nix
          ./devices/alice/hardware-configuration.nix
          lanzaboote.nixosModules.lanzaboote
        ] ++ self.devModules;
      };

      yuuna = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "aarch64-linux";
        modules = [
          ./devices/yuuna/configuration.nix
          ./devices/yuuna/hardware-configuration.nix
          nixos-hardware.nixosModules.raspberry-pi-4
        ] ++ self.deployableModules;
      };

      moshimoshi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/moshimoshi/configuration.nix
          ./devices/moshimoshi/hardware-configuration.nix
          ./devices/moshimoshi/disko.nix
          ./common/apps/tailscale.nix
        ] ++ self.deployableModules;
      };

      inanis = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/inanis/configuration.nix
          nixos-generators.nixosModules.all-formats
        ] ++ self.vmModules;
      };

      schwi = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/kube/nodes/schwi.nix
        ] ++ self.exMachinaModules;
      };

      emir-eins = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/kube/nodes/emir-eins.nix
        ]  ++ self.exMachinaModules;
      };

      emir-zwei = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        system = "x86_64-linux";
        modules = [
          ./devices/kube/nodes/emir-zwei.nix
        ]  ++ self.exMachinaModules;
      };
    };

    deploy.nodes = {
      yuuna = {
        hostname = "yuuna";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.yuuna;
        };
      };

      moshimoshi = {
        hostname = "moshimoshi";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.moshimoshi;
        };
      };

      schwi = {
        hostname = "schwi.ex-machina.sophiah.gay";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.schwi;
        };
      };

      emir-eins = {
        hostname = "emir-eins.ex-machina.sophiah.gay";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.emir-eins;
        };
      };

      emir-zwei = {
        hostname = "emir-zwei.ex-machina.sophiah.gay";
        profiles.system = {
          user = "root";
          path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.emir-zwei;
        };
      };
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
