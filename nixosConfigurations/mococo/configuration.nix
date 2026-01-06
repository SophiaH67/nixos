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

  virtualisation.docker = {
    enable = true;
    enableOnBoot = false;
    enableNvidia = true;
    autoPrune.enable = true;
    storageDriver = "overlay2";
    daemon = {
      settings = {
        data-root = "/persist/docker";
        experimental = true;
        ip6tables = true;
        dns = [
          "127.0.0.1"
          "1.1.1.1"
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
}
