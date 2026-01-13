{ pkgs, ... }:
{

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

  users.users.lux = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOHTI1LaYIWhJxDPLSyZOi62kXMf3HasHb6NAbh3bIqZ"
    ];
    extraGroups = [
      "wheel"
    ];
    shell = pkgs.zsh;
    uid = 1002;
  };
  home-manager.users.lux = {
    soph.base.enable = true;
  };

  users.users.paci = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCuc+Pm56oupBvjsaE94Dt1TVC50/pG++cim6qbuP9jPc5ZnZf4exX/dfEf4WU4pEAIHJVNyyE6TzlhtueTg7uT1UV63ZxFAWJIG1YFmNBIau7jTtJ1PLOW3ODCKM7jMLkIxfaqFDSHpzomRzwfXuHenunmyCV3il5kFgsMqeLNCxPzGpBLUJpUrSKCkPMwB67T92DBKdfQMJkYaxKBefRLOmJGpPci+ror9EbJBYkiGKDAIDdD2dfgM5MgS+gtulTvL+uz1nnmbrqqj8/KNGqfYFzfGIzmgkqUuRCxHvGpcAzzEnmU+EpEllzt2XHa/4rjVOuyDj/kRsFnw2fGOKFlauJFS8R4xdx7eqau9efYC0WVCqUtTtN8tnVldOWULf3sth1SRGPOscu3TnWdEyVRXmVZToEX9vuS1nHKnhdb1xPzVtbgVNBM85AY/qs6rd0Pf/8WNWY2ZtQVGUxBkF/ETxy/EOH+F8h9DlSGLemDCK6b214FXRgxBJyRPAg0GiGPixe93eeArtlT5ySi2RogRgeuk/idc5zL09Ni1n1X8yEkie8JfiRKY4ZdvNgFU/n6M6BHNNCMX9jUT8IEfWVMt8YYcvm6GH/xuqppq1TyIyrQPOPUi2qqjlXZnRrwUJsQd24OI9lSjGsUuivDd1WUrqDv/dQOcoiZaJDdiUYyHw=="
    ];
    extraGroups = [ "sshable" ];
    uid = 1004;
  };
  home-manager.users.paci = {
    soph.base.enable = true;
    home.packages = with pkgs; [ rsync ];
  };

  users.users.sophia.uid = 1000;
}
