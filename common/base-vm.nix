# base.nix with overrides to make it work in vms
{ lib, config, ... }:
{
  imports = [ ./base.nix ];

  boot.loader.systemd-boot.enable = lib.mkForce false;

  boot.kernelParams = [
    "console=tty1"
  ];
}