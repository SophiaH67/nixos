{ lib, pkgs, ... }:
{
  imports = [
    ./containers
  ];

  soph.base.enable = true;
  sophices.builder.enable = true;

  # https://grahamc.com/blog/erase-your-darlings/
  boot.initrd.postDeviceCommands = lib.mkAfter ''
    zfs rollback -r Fuwawa/local/root@blank
  '';

  networking.hostName = "mococo";
  networking.domain = "dev.sophiah.gay";

  users.mutableUsers = false; # Everything gets thrown out on reboot anyway
  home-manager.users.sophia = {
    sophrams.atuin.enable = lib.mkForce false;
  };

  services.zfs.autoScrub.enable = true;
  services.zfs.autoSnapshot.enable = true;
  services.zfs.trim.enable = true;

  sophices.boot-unlock.enable = true;

  services.openssh.hostKeys = [
    {
      path = "/persist/ssh/ssh_host_ed25519_key";
      type = "ed25519";
    }
    {
      path = "/persist/ssh/ssh_host_rsa_key";
      type = "rsa";
      bits = 4096;
    }
  ];

  networking.nftables.enable = true;

  sophices.docker.enable = true;
  virtualisation.docker.daemon.settings.data-root = lib.mkForce "/persist/docker";
  hardware.graphics.enable32Bit = true;

  networking.firewall = {
    allowedTCPPorts = [
      80
      443
      8123
      8448
      25564
      25565
      32400

      8384
      59500

      # Unifi
      8448
      8080
      6789
    ];
    allowedUDPPorts = [
      34197 # Factorio
      59500

      # Unifi
      1900
      3478
      10001
    ];
  };

  services.tailscale.extraDaemonFlags = [ "--statedir=/persist/tailscale" ];

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  networking.nat = {
    enable = true;
    internalInterfaces = [
      "ve-*"
      "ve-+"
    ];
    externalInterface = "eno1";
    enableIPv6 = true;
  };

  # Remove "127.0.0.2 mococo.dev.sophiah.gay mococo", which caused a lot of issues in docker
  networking.hosts = lib.mkForce {
    "127.0.0.1" = [ "localhost" ];
    "::1" = [ "localhost" ];
  };

  services.snowflake-proxy.enable = true;

  services.matrix-tuwunel = {
    enable = true;
    package = pkgs.matrix-tuwunel.overrideAttrs (old: {
      buildFeatures = builtins.filter (feature: feature != "release_max_log_level") old.buildFeatures;
    });
    settings = {
      global = {
        max_request_size = 1024 * 1024 * 1024; # 1 GiB
        server_name = "cat.sophiah.gay";
        new_user_displayname_suffix = "🩷";
        log = "debug";
        trusted_servers = [ "matrix.org" ];
        unix_socket_path = "/run/tuwunel/tuwunel.sock";
      };
    };
  };

  systemd.services.matrix-synapse.requires = [ "docker.service" ];
  services.matrix-synapse = {
    enable = true;
    configurePostgres = true;
    configureRedisLocally = true;
    enableRegistrationScript = false;
    domain = "soph.zip";
    settings = {
      server_name = "soph.zip";
      listeners = [
        {
          path = "/run/matrix-synapse/matrix-synapse.sock";
          resources = [
            {
              names = [
                "client"
                "federation"
              ];
              compress = false;
            }
          ];
        }
      ];
      oidc_providers = [
        {
          idp_id = "taiwan_auth_system";
          idp_name = "公民身份识别系统";
          issuer = "https://xn--15qt0w.xn--55q89qy6p.com";
          client_id = "82c5ed76-36b0-42b2-8458-75cefcd55e72";
          # Marked as public client, should be fine
          client_secret = "nMiOY8BatrgvkvNubKsypnjXPdBzXNOz";
          pkce_method = "always";
          scopes = [
            "openid"
            "profile"
            "email"
          ];
          authorization_endpoint = "https://xn--15qt0w.xn--55q89qy6p.com/authorize";
          token_endpoint = "https://xn--15qt0w.xn--55q89qy6p.com/api/oidc/token";
          userinfo_endpoint = "https://xn--15qt0w.xn--55q89qy6p.com/api/oidc/userinfo";

          user_mapping_provider.config = {
            localpart_template = "{{ user.preferred_username }}";
            display_name_template = "{{ user.display_name }}";
            email_template = "{{ user.email }}";
          };
        }
      ];
    };
  };

  environment.etc.cinny.source = pkgs.cinny-unwrapped;
}
