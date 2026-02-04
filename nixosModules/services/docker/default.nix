{
  config,
  lib,
  ...
}:
{
  options.sophices.docker.enable = lib.mkEnableOption "Soph Docker";

  config = lib.mkIf config.sophices.docker.enable {
    virtualisation.docker = {
      enable = true;
      enableOnBoot = true;
      autoPrune.enable = true;
      storageDriver = "overlay2";
      daemon = {
        settings = {
          data-root = "/persist/docker";
          experimental = true;
          ip6tables = true;
          ipv6 = true;
          fixed-cidr-v6 = "fd00:d0ca:2::/56";
          features.cdi = true;
          default-address-pools = [
            {
              base = "172.17.0.0/16";
              size = 16;
            }
            {
              base = "172.18.0.0/16";
              size = 16;
            }
            {
              base = "172.19.0.0/16";
              size = 16;
            }
            {
              base = "172.20.0.0/14";
              size = 16;
            }
            {
              base = "172.24.0.0/14";
              size = 16;
            }
            {
              base = "172.28.0.0/14";
              size = 16;
            }
            {
              base = "192.168.0.0/16";
              size = 20;
            }

            {
              base = "fd00:d0ca::/48";
              size = 64;
            }
          ];
        };
      };
    };
  };
}
