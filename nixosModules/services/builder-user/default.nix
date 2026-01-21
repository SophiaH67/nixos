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
        hostName = "${hostName}.isla";
        sshUser = "isla-builder";
        system = "x86_64-linux";
        protocol = "ssh-ng";
        supportedFeatures = [
          "nixos-test"
          "kvm"
        ];
      }) builderHostnames
    );

    programs.ssh = {
      extraConfig = lib.strings.join "\n" (
        map (hostName: ''
          Host ${hostName}.isla
            User isla-builder
            IdentityFile /etc/ssh/ssh_host_ed25519_key
            IdentitiesOnly yes
        '') builderHostnames
      );
    };
  };
}
