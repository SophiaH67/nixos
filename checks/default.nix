{ inputs, ... }:
{
  x86_64-linux =
    let
      pkgs = import inputs.nixpkgs { system = "x86_64-linux"; };
    in
    {
      formatting = (inputs.treefmt-nix.lib.evalModule pkgs ../treefmt.nix).x86_64-linux.config.build.check inputs.self;
    };
}
