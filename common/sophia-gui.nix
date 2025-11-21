{ pkgs, lib, config, ...}:
{
  imports = [ ./apps/comms.nix ];

  sophrams.gnome.enable = true;
  sophrams.gnome.autoLogin = "sophia";

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
  home-manager.users.sophia = { pkgs, ... }: {

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
        userName  = "Sophia Hage";
        userEmail = "sophia@sophiah.gay";
        signing = {
          key = "1FB01D6AA1106525";
          signByDefault = true;
        };
        extraConfig = {
          safe.directory = [ "/etc/nixos" ];
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
        package = (pkgs.vscode.overrideAttrs (
          final: prev: {
            preFixup =
              prev.preFixup
              + "gappsWrapperArgs+=( --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.gcc.cc.lib ]} )";
            postFixup =
              prev.postFixup
              + (if config.hardware.nvidia.enabled then "\nwrapProgram $out/bin/code --add-flags --ozone-platform=x11" else "");
          }
        ));
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
          };
          extensions = with pkgs.vscode-extensions; [
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
            ms-vscode.cmake-tools
            mkhl.direnv
            ms-vscode.hexeditor
            continue.continue
            wakatime.vscode-wakatime
          ]  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
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
      syncthing = {
        enable = true;
        overrideDevices = false;
        overrideFolders = false;
        guiAddress = "[::1]:8384";
        settings = {
          devices = {
            mococo = {
              id = "6IPUJU4-PX3VFSP-EZ3PNAU-7CVOXAG-476QTZB-4DEORJB-NB4B2XQ-WF72BAN";
            };
            rikka = {
              id = "H57XCEM-AE6HEL7-AOXSSIY-4JDLLCD-PZTAQFB-QQZBX2C-7UQVDM6-5QBAVAM";
            };
            ayumu = {
              id = "3WOL2NN-YEMHJEJ-KQ3NWIZ-2ZVEK6S-N3ADXL3-VNPJCKB-3ZLFBEY-FIFYQQX";
            };
            tyrants_eye = {
              id = "A3QLL5C-ARZUF27-VKUT5OY-6ZAVJS4-55VGXZ6-EGKH2AB-OVQZSUU-GCXGVQX";
            };
            alice = {
              id = "RXLKWVK-WRPWLP7-7ECMV7D-OJTTV6A-OTTDSX7-FFPLH7N-FDQLNBQ-FNUPGAV";
            };
          };
          folders = {
            "/home/sophia/sync" = {
              id = "nei9h-knicz";
              devices = [ "alice" "mococo" "ayumu" "rikka" ];
              label = "Soph's Nix Syncing";
            };
          };
        };
      };
    };
  };
}
