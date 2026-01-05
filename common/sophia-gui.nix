{
  pkgs,
  self,
  inputs,
  ...
}:
{
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
    self.packages.${system}.thirtyninec3-font
  ];

  nixpkgs.config.allowUnfree = true;
  home-manager.users.sophia = {
    soph.gui.enable = true;
  };
}
