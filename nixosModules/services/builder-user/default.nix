{ config, lib, pkgs, ...}:
{
  options.sophices.builder-user.enable = lib.mkEnableOption "Use Soph Builder System for builds";

  config = lib.mkIf config.sophices.builder-user.enable {
    age.secrets."soph-builder.id_ed25519".file = ../../../secrets/soph-builder.id_ed25519.age;

    nix.distributedBuilds = true;
    nix.settings.builders-use-substitutes = true;

    nix.buildMachines = [
      # Ex-machina
      {
        hostName = "schwi.ex-machina.sophiah.gay";
        sshUser = "soph-builder";
        sshKey = config.age.secrets."soph-builder.id_ed25519".path;
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUtQSHRKY1k4cTB4bS9KOEFrR2JYK2t4OTF6WHBvOEg4OTNtVUdxSmJsZ2ggcm9vdEBzY2h3aQo=";
        system = "x86_64-linux";
        supportedFeatures = [ "nixos-test" "kvm" ];
      }
      {
        hostName = "emir-eins.ex-machina.sophiah.gay";
        sshUser = "soph-builder";
        sshKey = config.age.secrets."soph-builder.id_ed25519".path;
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUhQU3NjUkVIOU9TNlY2dURVZ3RjbkVMR0JjalRac3FKZnNtZHUyOFEvK0Mgcm9vdEBlbWlyLWVpbnMK";
        system = "x86_64-linux";
        supportedFeatures = [ "nixos-test" "kvm" ];
      }
      {
        hostName = "emir-zwei.ex-machina.sophiah.gay";
        sshUser = "soph-builder";
        sshKey = config.age.secrets."soph-builder.id_ed25519".path;
        publicHostKey = "c3NoLWVkMjU1MTkgQUFBQUMzTnphQzFsWkRJMU5URTVBQUFBSUFkbS8yZ2VUNytQeFlVU1FlaU9MR3BjaHhhaWhNNUJ4dTg4UUtMWlZvWlQgcm9vdEBlbWlyLWVpbnMK";
        system = "x86_64-linux";
        supportedFeatures = [ "nixos-test" "kvm" ];
      }
      
    ];
  };
}
