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

  soph.comms.enable = true;
  sophrams.chromium.enable = true;

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
  home-manager.extraSpecialArgs = { inherit inputs; };
  home-manager.users.sophia = {
    imports = [
      ../homeManagerModules
    ];

    soph.gui.enable = true;
  };
}
