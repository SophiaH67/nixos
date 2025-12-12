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
  home-manager.users.sophia =
    { pkgs, ... }:
    {
      imports = [
        ../homeManagerModules
      ];

      sophices.syncthing.enable = true;
      soph.dev.enable = true;

      home.packages = with pkgs; [
        atool
        httpie
        nerd-fonts._0xproto
        nerd-fonts.droid-sans-mono
        cascadia-code
      ];
      fonts.fontconfig.enable = true;

      programs = {
        element-desktop = {
          enable = true;
          settings = ''
            {
              default_server_config = {
                "m.homeserver" = {
                    base_url = "https://cat.sophiah.gay";
                    server_name = "cat.sophiah.gay";
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
            }
          '';
        };
        htop = {
          enable = true;
          settings.show_cpu_temperature = 1;
        };
        git = {
          enable = true;
          userName = "Sophia Hage";
          userEmail = "sophia@sophiah.gay";
          signing = {
            key = "1FB01D6AA1106525";
            signByDefault = true;
          };
          extraConfig = {
            safe.directory = [ "/etc/nixos" ];
            blame.ignoreRevsFile = ".git-blame-ignore-revs";
          };
        };
        neovim = {
          enable = true;
          viAlias = true;
          vimAlias = true;
          plugins = [
            pkgs.vimPlugins.LazyVim
          ];
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
          theme = "CLRS";
          extraConfig = ''
            allow_remote_control yes
          '';
        };
      };
      services = {
        gpg-agent = {
          enable = true;
          enableSshSupport = false;
          sshKeys = [ "1FB01D6AA1106525" ];
          maxCacheTtl = 300;
        };
      };
    };
}
