{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.base-vm.enable = lib.mkEnableOption "Soph Nixos VM Base";

  config = lib.mkIf config.soph.base-vm.enable {
    soph.base.enable = true;

    boot.loader.systemd-boot.enable = lib.mkForce false;

    boot.kernelParams = [
      "console=tty1"
    ];
  };
}
