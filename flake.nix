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
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, deploy-rs, disko, nixos-generators, agenix, ... }: {
    baseModules = [
      ./common/base.nix
      ./common/sophia.nix
      home-manager.nixosModules.home-manager
      agenix.nixosModules.default
    ];

    devModules = [
      ./common/sophia-dev.nix
      ./common/sophia-gui.nix
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

    nixosConfigurations = {
      rikka = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/rikka/configuration.nix
          ./devices/rikka/hardware-configuration.nix
          lanzaboote.nixosModules.lanzaboote
        ] ++ self.devModules;
      };

      asuna = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/asuna/configuration.nix
          ./devices/asuna/hardware-configuration.nix
          lanzaboote.nixosModules.lanzaboote
        ] ++ self.devModules;
      };

      yuuna = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./devices/yuuna/configuration.nix
          ./devices/yuuna/hardware-configuration.nix
        ] ++ self.deployableModules;
      };

      moshimoshi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/moshimoshi/configuration.nix
          ./devices/moshimoshi/hardware-configuration.nix
          ./devices/moshimoshi/disko.nix
          ./common/apps/tailscale.nix
        ] ++ self.deployableModules;
      };

      ninomae = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/ninomae/configuration.nix
        ] ++ self.baseModules;
      };

      schwi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/kube/nodes/schwi.nix
        ] ++ self.exMachinaModules;
      };

      emir-eins = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/kube/nodes/emir-eins.nix
        ]  ++ self.exMachinaModules;
      };

      emir-zwei = nixpkgs.lib.nixosSystem {
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
