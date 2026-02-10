{
  containers.matrix2 = {
    autoStart = true;
    privateNetwork = true;
    # privateUsers = "pick";

    hostAddress6 = "fc00::1";
    localAddress6 = "fc00::12";
    hostAddress = "192.168.100.10";
    localAddress = "192.168.100.11";

    bindMounts = {
      "/var/lib" = {
        hostPath = "/Fuwawa/appdata/matrix/";
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
        services.matrix-tuwunel = {
          enable = true;
          settings = {
            global = {
              address = [ "::" ];
              max_request_size = 1024 * 1024 * 1024; # 1 GiB
              server_name = "cat.sophiah.gay";
              new_user_displayname_suffix = "🩷";
              trusted_servers = [ "matrix.org" ];
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

        networking = {
          firewall.allowedTCPPorts = config.services.matrix-tuwunel.settings.global.port;

          # Use systemd-resolved inside the container
          # Workaround for bug https://github.com/NixOS/nixpkgs/issues/162686
          useHostResolvConf = lib.mkForce false;
        };

        services.resolved.enable = true;

        system.stateVersion = "26.05";
      };
  };
}
