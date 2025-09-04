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
  };

  outputs = { self, nixpkgs, home-manager, lanzaboote }: {

    packages.x86_64-linux.hello = nixpkgs.legacyPackages.x86_64-linux.hello;

    packages.x86_64-linux.default = self.packages.x86_64-linux.hello;

    nixosConfigurations = {
      yuzaki = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./devices/yuzaki/configuration.nix
          ./common/base.nix
          home-manager.nixosModules.home-manager
          lanzaboote.nixosModules.lanzaboote
        ];
      };
    };

  };
}
