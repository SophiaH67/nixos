{
  config,
  lib,
  inputs,
  pkgs,
  ...
}:
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-generators.nixosModules.all-formats
  ];

  options.soph.base-gui.enable = lib.mkEnableOption "Soph Nixos Base-Gui";

  config = lib.mkIf config.soph.base-gui.enable {
    sophrams.gnome.enable = true;
    sophrams.gnome.autoLogin = "sophia";

    sophrams.chromium.enable = true;

    hardware.bluetooth.enable = true;
    hardware.bluetooth.settings = {
      General = {
        DeviceID = "bluetooth:004C:0000:0000";
      };
    };

    fonts.packages = with pkgs; [
      nerd-fonts._0xproto
      nerd-fonts.fira-code
      nerd-fonts.droid-sans-mono
      noto-fonts-cjk-sans
      noto-fonts-cjk-serif
      self.packages.${system}.thirtyninec3-font
    ];

    home-manager.users.sophia = {
      soph.gui.enable = true;
      sophrams.gnome.enable = true;
    };
  };
}
