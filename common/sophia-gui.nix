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
        firefox = {
          enable = true;
          package = pkgs.firefox;
          policies = {
            DisablePocket = true;
            DisableFirefoxStudies = true;
            DisableFeedbackCommands = true;
            DisableMasterPasswordCreation = true;
            DisablePasswordReveal = true;
            DisableProfileImport = true;
            DisableProfileRefresh = true;
            DisableSetDesktopBackground = true;
            DisableTelemetry = true;
            DontCheckDefaultBrowser = true;
            EnableTrackingProtection = true;
            PasswordManagerEnabled = false;
            Extensions = {
              Install = [
                "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/privacy-badger/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/deadname-remover/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/bitwarden-password-manager/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/single-file/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/vimium-c/latest.xpi"
                "https://addons.mozilla.org/firefox/downloads/latest/simplelogin/latest.xpi"
              ];
            };
            FirefoxHome = {
              SponsoredTopSites = false;
              Pocket = false;
              SponsoredPocket = false;
            };
            Preferences = {
              general.smoothScroll = true;
              browser.search.region = "NL";
              browser.startup.page = 3; # This means restore previous tabs
              trailhead.firstrun.didSeeAboutWelcome = true;
              # Make firefox not mess with pipewire
              media.getusermedia.agc = 0;
              media.getusermedia.agc2_forced = false;
              media.getusermedia.agc_enabled = false;
            };
          };
          profiles.sophia = {
            search.default = "ggl";
            search.privateDefault = "ggl";
            search.force = true;
          };
          #nativeMessagingHosts.packages = [ pkgs.plasma5Packages.plasma-browser-integration ];
          #preferences = {
          #  "widget.use-xdg-desktop-portal.file-picker" = 1;
          #};
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
        vscode = {
          enable = true;
          # https://www.reddit.com/r/NixOS/comments/15mohek/installing_vscode_extensions_with_homemanager_not/
          mutableExtensionsDir = false;
          # https://github.com/continuedev/continue/issues/821#issuecomment-3227673526
          package = (
            pkgs.vscode.overrideAttrs (
              final: prev: {
                preFixup =
                  prev.preFixup
                  + "gappsWrapperArgs+=( --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.gcc.cc.lib ]} )";
                postFixup =
                  prev.postFixup
                  + (
                    if config.hardware.nvidia.enabled then
                      "\nwrapProgram $out/bin/code --add-flags --ozone-platform=x11"
                    else
                      ""
                  );
              }
            )
          );
          profiles.default = {
            userSettings = {
              git.confirmSync = false;
              git.enableSmartCommit = true;
              git.autofetch = true;
              git.replaceTagsWhenPull = true;
              git.autoStash = true;
              editor.cursorSmoothCaretAnimation = "on";
              files.autoSave = "afterDelay";
              terminal.integrated.enableMultiLinePasteWarning = false;
              prohe.serverAddress = "ws://192.168.67.26:12345";
              prohe.typingWindow = 10000;
              prohe.vibrationMax = 1;
              workbench.iconTheme = "material-icon-theme";
              window.autoDetectColorScheme = true;
              workbench.colorTheme = "98878c8e-9f91-4e25-930d-dd7d280d9e35";
              workbench.preferredDarkColorTheme = "5412c41d-f76b-4488-85a7-1ae1a63bbfcc";
              editor.fontFamily = "'Cascadia Code',Consolas, 'Courier New', monospace";
              terminal.integrated.stickyScroll.enabled = false;
              chat.disableAIFeatures = true;
              nix.enableLanguageServer = true;
              nix.serverPath = "${pkgs.nixd}/bin/nixd";
            };
            extensions =
              with pkgs.vscode-extensions;
              [
                yzhang.markdown-all-in-one
                github.vscode-pull-request-github
                github.vscode-github-actions
                ms-vscode-remote.remote-ssh
                yoavbls.pretty-ts-errors
                prisma.prisma
                pkief.material-icon-theme
                esbenp.prettier-vscode
                eamodio.gitlens
                leonardssh.vscord
                stkb.rewrap
                jnoortheen.nix-ide
                llvm-vs-code-extensions.vscode-clangd
                llvm-vs-code-extensions.lldb-dap
                ms-dotnettools.csdevkit
                ms-dotnettools.csharp
                ms-vscode.cmake-tools
                ms-dotnettools.vscode-dotnet-runtime
                mkhl.direnv
                ms-vscode.hexeditor
                continue.continue
                wakatime.vscode-wakatime
              ]
              ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
                {
                  name = "prohe";
                  publisher = "UncensorPat";
                  version = "0.1.0";
                  sha256 = "mq4SP+FM3rMOYf9e6lmPcxQQn2CpgN95L3J6mXlHY1s=";
                }
                {
                  name = "doki-theme";
                  publisher = "unthrottled";
                  version = "88.1.18";
                  sha256 = "7Ditwj7U26t3v4ofpqw/sHar6uE46E4DWVwGZjziZfM=";
                }
                {
                  name = "emoji";
                  publisher = "perkovec";
                  version = "1.0.1";
                  sha256 = "vHKmXbeXKRyVqLuhvFagv9Q1WdHNL7a0q+rgOGOFi5o=";
                }
                {
                  name = "vscode-conventional-commits";
                  publisher = "vivaxy";
                  version = "1.26.0";
                  sha256 = "Lj2+rlrKm9h21zEoXwa2TeGFNKBmlQKr7MRX0zgngdg=";
                }
                {
                  name = "kdl";
                  publisher = "kdl-org";
                  version = "2.1.3";
                  sha256 = "Jssmb5owrgNWlmLFSKCgqMJKp3sPpOrlEUBwzZSSpbM=";
                }
              ];
          };
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
