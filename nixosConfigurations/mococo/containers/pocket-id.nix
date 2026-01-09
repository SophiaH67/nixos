{ inputs, ... }:
{
  containers.pocket-id = {
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

        age.secrets."pocketid-smtppassword" = {
          file = ../../../secrets/pocketid-smtppassword.age;
          mode = "444";
        };

        services.pocket-id = {
          enable = true;

          dataDir = "/data";
          settings = {
            APP_URL = "https://xn--15qt0w.xn--55q89qy6p.com";
            APP_NAME = "安全好公民";
            TRUST_PROXY = true;

            ENCRYPTION_KEY_FILE = config.age.secrets."pocketid-encryptionkey".path;
            MAXMIND_LICENSE_KEY_FILE = config.age.secrets."pocketid-maxmind".path;

            SMTP_HOST = "smtp.fastmail.com";
            SMTP_PORT = 465;
            SMTP_FROM = "auth@xn--55q89qy6p.com";
            SMTP_USER = "sophia@roboco.dev";
            SMTP_PASSWORD_FILE = config.age.secrets."pocketid-smtppassword".path;
            SMTP_TLS = "tls";
          };
        };

        networking = {
          firewall.allowedTCPPorts = [ 1411 ];

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;

          extraHosts = "2a01:4f8:c2c:123f:64:5:67a8:ac2d smtp.fastmail.com"; # temporarily route thru dns64.net
        };

        services.resolved.enable = true;

        system.stateVersion = "26.05";
      };
  };
}
