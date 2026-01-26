{
  config,
  lib,
  self,
  ...
}:
let
  builderHostnames =
    let
      builderEnabled = builtins.filter (
        name: self.nixosConfigurations.${name}.config.sophices.builder.enable
      ) (builtins.attrNames self.nixosConfigurations);
    in
    map (name: self.nixosConfigurations.${name}.config.networking.hostName) builderEnabled;

  speedFactors = {
    mococo = 20;
    ayumu = 30;
    emir-eins = 5;
    emir-zwei = 5;
    schwi = 5;
  };
in
{
  options.sophices.builder-user.enable = lib.mkOption {
    type = lib.types.bool;
    default = config.sophices.isla.enable && !config.sophices.builder.enable;
    description = "Use Soph Builder System for builds";
  };

  config = lib.mkIf config.sophices.builder-user.enable {
    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines = (
      map (hostName: {
        hostName = "builder.${hostName}.isla";
        sshUser = "isla-builder";
        system = "x86_64-linux";
        # No ssh-ng because no support yet for builders-use-substitutes
        # https://github.com/NixOS/nix/issues/4665
        protocol = "ssh";
        supportedFeatures = [
          "nixos-test"
          "kvm"
        ];
        speedFactor = if builtins.hasAttr hostName speedFactors then speedFactors.${hostName} else 10;
      }) builderHostnames
    );

    programs.ssh = {
      extraConfig = lib.strings.join "\n" (
        map (hostName: ''
          Host builder.${hostName}.isla
            HostName ${hostName}.isla
            User isla-builder
            IdentityFile /etc/ssh/ssh_host_ed25519_key
            IdentitiesOnly yes
            ConnectTimeout 5
        '') builderHostnames
      );
    };
  };
}
