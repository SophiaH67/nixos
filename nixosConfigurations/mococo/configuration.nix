{ lib, pkgs, ... }:
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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = true;
    enableNvidia = true;
    autoPrune.enable = true;
    storageDriver = "overlay2";
    daemon = {
      settings = {
        data-root = "/persist/docker";
        experimental = true;
        ip6tables = true;
        ipv6 = true;
        fixed-cidr-v6 = "fd00:d0ca:2::/56";
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
    ];
    allowedUDPPorts = [
      34197 # Factorio
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
}
