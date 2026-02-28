{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.soph.gui.enable = lib.mkEnableOption "Soph Homemanager Gui Base";

  config = lib.mkIf config.soph.gui.enable {
    sophices.syncthing.enable = true;
    soph.dev.enable = true;
    sophrams.ghostty.enable = true;
    sophrams.discord.enable = true;
    sophrams.keepassxc.enable = true;

    home.packages = with pkgs; [
      atool
      httpie
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
      cascadia-code
      filezilla
      gedit
      gparted
      xeyes
      # tor-browser
      qpwgraph
      pwvucontrol
      cavalier
      inputs.librepods.packages.${stdenv.hostPlatform.system}.default
      gnupg # required until https://github.com/NixOS/nixpkgs/issues/473387 is fixed
      waypipe
      easyeffects
      wl-clipboard
      ffmpeg
      spotify
      plex-desktop
      wifi-qr
      ghex
      parsec-bin
      obsidian
      # Office things
      libreoffice
      hyphenDicts.en_GB
      hyphenDicts.nl_NL
      hyphenDicts.de_DE
      hunspellDicts.en_GB-large
      hunspellDicts.nl_NL
      hunspellDicts.de_DE
    ];
    fonts.fontconfig.enable = true;

    programs = {
      element-desktop = {
        enable = true;
        settings = {
          default_server_config = {
            "m.homeserver" = {
              base_url = "https://soph.zip";
              server_name = "soph.zip";
            };
            "m.identity_server" = {
              base_url = "https://vector.im";
            };
          };
          disable_custom_urls = false;
          disable_guests = false;
          disable_login_language_selector = false;
          disable_3pid_login = false;
          force_verification = false;
          brand = "Element";
          integrations_ui_url = "https://scalar.vector.im/";
          integrations_rest_url = "https://scalar.vector.im/api";
        };
      };
      gpg = {
        enable = true;
      };
      kitty = {
        enable = true;
        font = {
          name = "CaskaydiaCove NF Regular";
          size = 11;
        };
        themeFile = "CLRS";
        extraConfig = ''
          allow_remote_control yes
        '';
      };
    };
  };
}
