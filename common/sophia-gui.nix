{
  pkgs,
  lib,
  config,
  inputs,
  ...
}:
{
  imports = [ ./apps/comms.nix ];

  sophrams.gnome.enable = true;
  sophrams.gnome.autoLogin = "sophia";

  services.earlyoom.enable = true;
  services.earlyoom.enableNotifications = true;

  soph.comms.enable = true;
  sophrams.chromium.enable = true;

  users.users.sophia.packages = with pkgs; [
    filezilla
    gedit
    gparted
    xorg.xeyes
    tor-browser
    qpwgraph
    pwvucontrol
    cavalier
    inputs.librepods.packages.${stdenv.system}.default
  ];

  fonts.packages = with pkgs; [
    nerd-fonts._0xproto
    nerd-fonts.fira-code
    nerd-fonts.droid-sans-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.sophia = {
    imports = [
      ../homeManagerModules
    ];

    soph.gui.enable = true;
  };
}
