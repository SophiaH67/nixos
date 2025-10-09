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

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations = {
      yuzaki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/yuzaki/configuration.nix
          ./devices/yuzaki/hardware-configuration.nix
          ./common/base.nix
          ./common/sophia.nix
          ./common/sophia-gui.nix
          ./common/sophia-dev.nix
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };

      asuna = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/asuna/configuration.nix
          ./devices/asuna/hardware-configuration.nix
          ./devices/yuzaki/configuration.nix
          ./common/base.nix
          ./common/sophia.nix
          ./common/sophia-dev.nix
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
          agenix.nixosModules.default
          {
            environment.systemPackages = [ agenix.packages.x86_64-linux.default ];
          }
        ];
      };

      yuuna = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./devices/yuuna/configuration.nix
          ./devices/yuuna/hardware-configuration.nix
          ./common/base.nix
          ./common/sophia.nix
          ./common/forgejo.nix
          home-manager.nixosModules.home-manager
        ];
      };

      moshimoshi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./devices/moshimoshi/configuration.nix
          ./devices/moshimoshi/hardware-configuration.nix
          ./devices/moshimoshi/disko.nix
          ./common/base.nix
          ./common/apps/tailscale.nix
          ./common/sophia.nix
          ./common/forgejo.nix
          home-manager.nixosModules.home-manager
        ];
      };

      ninomae = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/ninomae/configuration.nix
          ./common/base.nix
          ./common/sophia.nix
          ./common/forgejo.nix
          # ./common/vm-able.nix
          home-manager.nixosModules.home-manager
          nixos-generators.nixosModules.all-formats
        ];
      };

      schwi = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./devices/kube/nodes/schwi.nix
          ./devices/kube/nodes/hardware-configuration.nix
          ./devices/kube/nodes/disko.nix
          ./common/base.nix
          ./common/sophia.nix
          ./common/forgejo.nix
          ./common/vm-able.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
      };

      emir-eins = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./devices/kube/nodes/emir-eins.nix
          ./devices/kube/nodes/hardware-configuration.nix
          ./devices/kube/nodes/disko.nix
          ./common/base.nix
          ./common/sophia.nix
          ./common/forgejo.nix
          ./common/vm-able.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
      };

      emir-zwei = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          disko.nixosModules.disko
          ./devices/kube/nodes/emir-zwei.nix
          ./devices/kube/nodes/hardware-configuration.nix
          ./devices/kube/nodes/disko.nix
          ./common/base.nix
          ./common/sophia.nix
          ./common/forgejo.nix
          ./common/vm-able.nix
          home-manager.nixosModules.home-manager
          agenix.nixosModules.default
        ];
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
