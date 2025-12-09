{ config, pkgs, ... }:
{
  users.groups.alice = { };
  users.users.alice = {
    description = "Alice User (mainly for proxying)";
    group = "alice";
    extraGroups = [
      "sshable"
      "wheel"
    ];
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC3kL6zYFM19TI987keNBlY8TLyPeRezGlT0ONrcl4ZmsRxQ/UCYyzJryo0mBTcTjTHoLT1W4h2zJ4fhBesJhaHvLp0+KmspTNLr72Bzn3csYNvtW8hjyXnv7DxreZxSrgsthwmzR56oykvlT13MKXCgzitcOxY0+bMykWaAH1ob8/z29MX/U1u3zMAG7IAH8qagJAwAX8n2AhHVFe5zmTAbIlv0s/P/OWHBBPTwASWX1MHJpXu2X9M3F6eJbIvYbzrkfW7c1EnwSDyixyrD4Ih4u+AJ4sHh3OLCW5CyD6vIiqHsEwe1AWZtpFAG/1JoRaNeJ8vNGJrr5evY3JrIeZse7TRDNvqwrKbgLyZWiQfMvoNsqhU0qQOMw0affPzbSFZUk4Grh5p9shbnXbGxY55ZdusEeyeuEGBA5TpOcabnqX5tYJeFoA2zRIEfJzQpjhknl9Wdnehkn/4BsXstGdOu5D2eYPU6OCLPNbT0gFL45brnLbtTmI7GgwmOXPKb0wQ32tuK5G6DCyJgnJK3UVJPsIGBRQ4XsvHMSbag/6jaYrB1K1WCEs38j2cGj9LfEiKBPAAhM60f9+uObwDYELkiejFuFYJaYEvxa9z9jD6sxkvOYt7ZS7x8xMbXvcFDXwWbpe0ZGCNJW3tbCGLjTzLoVsUfnygkfoo9cnPtjdnew== shage2@allegion.com"
    ];

    isNormalUser = true;
    packages = with pkgs; [ zsh ];
    shell = pkgs.zsh;
  };
}
