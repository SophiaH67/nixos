{
  description = "A very basic flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";

    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    rust-overlay.url = "github:oxalica/rust-overlay";
    rust-overlay.inputs.nixpkgs.follows = "nixpkgs";

    lanzaboote.url = "github:nix-community/lanzaboote/v0.4.2";
    lanzaboote.inputs.nixpkgs.follows = "nixpkgs";
    lanzaboote.inputs.rust-overlay.follows = "rust-overlay";

    nixos-generators.url = "github:nix-community/nixos-generators";
    nixos-generators.inputs.nixpkgs.follows = "nixpkgs";

    deploy-rs.url = "github:serokell/deploy-rs";
    deploy-rs.inputs.nixpkgs.follows = "nixpkgs";

    disko.url = "github:nix-community/disko";
    disko.inputs.nixpkgs.follows = "nixpkgs";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    agenix.inputs.home-manager.follows = "home-manager";

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    nixpkgs-xr.url = "github:nix-community/nixpkgs-xr";
    nixpkgs-xr.inputs.nixpkgs.follows = "nixpkgs";
    nixpkgs-xr.inputs.treefmt-nix.follows = "treefmt-nix";

    aagl.url = "github:ezKEa/aagl-gtk-on-nix";
    aagl.inputs.nixpkgs.follows = "nixpkgs";
    aagl.inputs.rust-overlay.follows = "rust-overlay";

    librepods.url = "github:kavishdevar/librepods?ref=linux/rust";
    librepods.inputs.nixpkgs.follows = "nixpkgs";

    nixcord.url = "github:kaylorben/nixcord";
    nixcord.inputs.nixpkgs.follows = "nixpkgs";

    kubenix.url = "github:hall/kubenix";
    kubenix.inputs.nixpkgs.follows = "nixpkgs";

    niri.url = "github:sodiboo/niri-flake";
    niri.inputs.nixpkgs.follows = "nixpkgs";
    niri.inputs.nixpkgs-stable.follows = "nixpkgs";

    treefmt-nix.url = "github:numtide/treefmt-nix";
    treefmt-nix.inputs.nixpkgs.follows = "nixpkgs";
    systems.url = "github:nix-systems/default";

    vcxproj2cmake.url = "github:SophiaH67/vcxproj2cmake";
    vcxproj2cmake.inputs.nixpkgs.follows = "nixpkgs";
  };

  nixConfig = {
    extra-substituters = [
      "https://niri.cachix.org"
      "https://cache.nixos-cuda.org"
    ];
    extra-trusted-public-keys = [
      "niri.cachix.org-1:Wv0OmO7PsuocRKzfDoJ3mulSl7Z6oezYhGhR+3W2964="
      "cache.nixos-cuda.org:74DUi4Ye579gUqzH4ziL9IyiJBlDpMRn9MBN8oNan9M="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      deploy-rs,
      disko,
      nixos-generators,
      agenix,
      nixos-hardware,
      treefmt-nix,
      systems,
      ...
    }@inputs:
    let
      # Small tool to iterate over each systems
      eachSystem = f: nixpkgs.lib.genAttrs (import systems) (system: f nixpkgs.legacyPackages.${system});

      # Eval the treefmt modules from ./treefmt.nix
      treefmtEval = eachSystem (pkgs: treefmt-nix.lib.evalModule pkgs ./treefmt.nix);
    in
    {
      nixosConfigurations = import ./nixosConfigurations { inherit inputs self; };
      packages = import ./packages inputs;

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

        kiara = {
          hostname = "kiara.dev.sophiah.gay";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.aarch64-linux.activate.nixos self.nixosConfigurations.kiara;
          };
        };

        mococo = {
          hostname = "mococo.dev.sophiah.gay";
          profiles.system = {
            user = "root";
            path = deploy-rs.lib.x86_64-linux.activate.nixos self.nixosConfigurations.mococo;
          };
        };
      };

      checks = import ./checks inputs;

      formatter = eachSystem (pkgs: treefmtEval.${pkgs.system}.config.build.wrapper);
    };
}
