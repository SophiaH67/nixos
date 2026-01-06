{ inputs, ... }:
{
  containers.pocketid = {
    autoStart = true;
    privateNetwork = true;
    # privateUsers = "pick";

    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::2";

    bindMounts = {
      "/data" = {
        hostPath = "/Fuwawa/appdata/pocked-id/";
        isReadOnly = false;
      };
    };

    ephemeral = true;

    config =
      {
        lib,
        config,
        ...
      }:
      {
        imports = [ inputs.agenix.nixosModules.default ];

        age.identityPaths = [ "/data/id_ed25519" ];

        age.secrets."pocketid-encryptionkey" = {
          file = ../../../secrets/pocketid-encryptionkey.age;
          mode = "444";
        };

        age.secrets."pocketid-maxmind" = {
          file = ../../../secrets/pocketid-maxmind.age;
          mode = "444";
        };

        services.pocket-id = {
          enable = true;

          dataDir = "/data";
          settings = {
            APP_URL = "https://auth.soph.zip"; # Maybe migrate to chinese domain later and make soph.zip git? idk
            TRUST_PROXY = true;
 
            ENCRYPTION_KEY_FILE = config.age.secrets."pocketid-encryptionkey".path;
            MAXMIND_LICENSE_KEY_FILE = config.age.secrets."pocketid-maxmind".path;
          };
        };

        networking = {
          firewall.allowedTCPPorts = [ 1411 ];

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;

        system.stateVersion = "26.05";
      };
  };
}
