{ inputs, self, ... }:
{
  yukihana-lamy = inputs.robotnix.lib.robotnixSystem {
    _module.args = { inherit self; };
    imports = [
      ./yukihana-lamy/configuration.nix
      self.robotnixModules.default
    ];
  };

  uruha-rushia = inputs.robotnix.lib.robotnixSystem {
    _module.args = { inherit self; };
    imports = [
      ./uruha-rushia/configuration.nix
      self.robotnixModules.default
    ];
  };
}
