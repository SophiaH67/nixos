# {"prefix":"fd31:aceb:1::/48","maxLength":48,"asn":"AS4242423167"}
{ inputs, ... }:
{
  containers.dn42-router = {
    autoStart = true;

    bindMounts = {
      "/data" = {
        hostPath = "/Fuwawa/appdata/dn42/";
        isReadOnly = false;
      };
    };

    enableTun = true;

    macvlans = [ "eno1" ];

    config =
      {
        config,
        lib,
        ...
      }:
      {
        imports = [ inputs.agenix.nixosModules.default ];

        age.identityPaths = [ "/data/id_ed25519" ];

        age.secrets."dn42-wgpriv" = {
          file = ../../../secrets/dn42-wgpriv.age;
          mode = "444";
        };

        networking = {
          nat = {
            enable = true;
          };

          interfaces.mv-eno1.useDHCP = true;

          wireguard = {
            enable = true;
            interfaces.wg0 = {
              # Public key: sophiaUETgsjq0+NeeQ88RfUnDHbEQ48w9H1+jZBSz4=
              privateKeyFile = config.age.secrets."dn42-wgpriv".path;
              listenPort = 51842;
              ips = [
                # Okay so etwas is fe80::acab, this means fe80:: is our link local, acab is her address.
                # I should be able to jut take a different address and be fine...
                "fe80::3167/64"
              ];
              peers = [
                {
                  name = "etwas";
                  allowedIPs = [
                    "fe80::acab" # Maybe??
                  ];
                  endpoint = "ncvps.dn42.etwas.me:22273";
                  publicKey = "gHC8pmVSKgfFVXHWHSkd4zajq2Of/JRtmynMJeTvqkE=";
                }
              ];
            };
          };

          firewall = {
            enable = true;
            allowedUDPPorts = [ 51842 ];
          };

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;
      };
  };
}
