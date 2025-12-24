{ lib, pkgs, ... }:
{
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

  users.users.fredi_68 = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDFOloBbTFtILqvi7g4bJevKjaov8WniluFl1GItqeAj31k9VX0I0PD0WW0E6LrtPpu6USSd2nCENSa6tzs/lZlDgUI7z9E4gaQguEFjog1GWC03spdz1wFfZ752CxQflwQp0ecPte6rQCbfq9UHmwRAPerdrFgZ0h8irU9p758VgTFthU2a5KJWdtFrpwTBcVNKjvA7TYqKx/AHV2DBZiVz8m9Pmx5eE/c/cCDzzcAHakA6mZtEOQSA8461bYpGuCRTTExHkt0xxPY+vubtZZK080XATpuPEGhGO8+5jRRlmToBAIWZO6VQZS7pKDK9KZ2QY0PVBii5v7WmvZuDWP2TsiKAOW2OnTs+DOA7j+jGMHbImNhQ/6yqriN+OG6vJkQ3/zPPER88Ou4NrZOK9i3BLu6/TPoQ8wAMgj27dO+qH5XyLiikM+Ue//7Z7uZLkgc0B2nBMvcI4QGV9fNgo163JFCiF4Py7+tXNtL5pmlJDHZkwTC/Zk9g+rkGVotvEwfYfpLQhLOIGkjcK2vYQxUUeuTXfjJmaF6bCDQLtUJEsKCOSwQT8LruY2I9kTC2xWFiKticxQUk0+NG5dYc4ufWCRJ07WmbHZhbwwLODfAWVy3peuCNeRRYyxqBUevMYAUbYguSn4W6yRo+N121t5hSIwmjrwtHc/IG0Dy0sHeGw=="
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDVoguWqP2ivIfWEkXNbtTvzu1ot9MeYrbS+uT+LqEVJ+5dXKeROKQoRUz2SLxGurq8vLSSyw+T/FuAHvshZPfxWu3MVTSd3MBX5v1yssuNOp+Moe49cdVCRHPeGIAc6x3lIykc4GYRe6bIp1TknObAg8bKZ608lKBYDYEj/XArm/yHLv6oiAV44eNqt7H3bZnPcuJ/6tS4rjVBn1OENKbM1LofceeqIJqt0Tv5MAMVVUeY4MmSPkF28i0CR6fx0OiVT3gT4ovHoWKGJxDk5ISzu86wsoooAzYKVdldCaCWGQHqSBo+TJJ6HhsOHExEYHz36Leo6EknU1rWKBfwH7IzCiMQdjLw1fHohu96oYY3xkXvF4LYf0kTLhDCQiE47r+jEd+L0EbFEc8OBmzBsx2q0cqy6Rf5RMS9qEKoH8nhFeZ3KhWzTK/o05bppdf9pEQmj7HSpBZoc6GaCJjYhDVwYAvQaHdTEAFz1jLNDrt+QuPniq3FIOgdQbuhSyXX8g0="
    ];
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    # This is fredi
    # Fredi is special
    # Fredi doesn't use nix
    home = "/persist/home/fredi_68";
    uid = 1003;
  };

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
    ];
  };

  sophices.tailscale.enable = true;
  services.tailscale.extraDaemonFlags = [ "--statedir=/persist/tailscale" ];
}
