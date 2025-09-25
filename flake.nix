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

    deploy-rs.url = "github:serokell/deploy-rs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote, deploy-rs, disko }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations = {
      yuzaki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/yuzaki/configuration.nix
          ./common/base.nix
          ./common/sophia.nix
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
        ];
      };

      yuuna = nixpkgs.lib.nixosSystem {
        system = "aarch64-linux";
        modules = [
          ./devices/yuuna/configuration.nix
          ./devices/yuuna/hardware-configuration.nix
          ./common/base.nix
          ./common/sophia.nix
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
    };

    checks = builtins.mapAttrs (system: deployLib: deployLib.deployChecks self.deploy) deploy-rs.lib;
  };
}
