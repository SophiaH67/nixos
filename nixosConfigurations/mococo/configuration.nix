{ lib, ... }:
{
  imports = [
    ./containers
  ];

  soph.base.enable = true;

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

  fileSystems = {
    "/var/lib/tuwunel" = {
      options = [ "bind" ];
      device = "/Fuwawa/appdata/matrix/private/tuwunel";
    };
  };
  services.matrix-tuwunel = {
    enable = true;
    settings = {
      global = {
        max_request_size = 1024 * 1024 * 1024; # 1 GiB
        server_name = "cat.sophiah.gay";
        new_user_displayname_suffix = "🩷";
        trusted_servers = [ "matrix.org" ];
        unix_socket_path = "/run/tuwunel/tuwunel.sock";
        # identity_provider = [
        #   {
        #     brand = "pocketid";
        #     client_id = "82c5ed76-36b0-42b2-8458-75cefcd55e72";
        #     client_secret = ""; # Still has to be set for some reason
        #     client_secret_file = "/var/lib/.client-secret";
        #     name = "公民身份识别系统";
        #     scope = [ "matrix" ];
        #     # discovery_url = "https://xn--15qt0w.xn--55q89qy6p.com/.well-known/openid-configuration";
        #   }
        # ];
      };
    };
  };
}
