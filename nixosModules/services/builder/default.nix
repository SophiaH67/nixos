{
  config,
  lib,
  self,
  ...
}:
let
  deviceKeys = import ../../../secrets/deviceKeys.nix;

  builderUserHostnames =
    let
      builderEnabled = builtins.filter (
        name:
        self.nixosConfigurations.${name}.config.sophices.builder-user.enable
        && (builtins.hasAttr name deviceKeys)
      ) (builtins.attrNames self.nixosConfigurations);
    in
    map (name: self.nixosConfigurations.${name}.config.networking.hostName) builderEnabled;
in
{
  options.sophices.builder.enable = lib.mkEnableOption "Soph Builder System";

  config = lib.mkIf config.sophices.builder.enable {
    sophices.isla.enable = true; # We only allow builds over isla

    users.groups.isla-builder = { };
    users.users.isla-builder = {
      isSystemUser = true;
      group = "isla-builder";
      extraGroups = [
        "isla-sshable"
      ];

      useDefaultShell = true;

      openssh.authorizedKeys.keys = map (name: deviceKeys.${name}) builderUserHostnames;
    };

    users.groups.soph-builder = { };

    # https://nix.dev/tutorials/nixos/distributed-builds-setup.html#optimise-the-remote-builder-configuration
    nix = {
      nrBuildUsers = 64;
      settings = {
        trusted-users = [ "isla-builder" ];
      };
    };

    systemd.services.nix-daemon.serviceConfig = {
      MemoryAccounting = true;
      MemoryMax = "90%";
      OOMScoreAdjust = 500;
    };
  };
}
