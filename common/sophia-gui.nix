{ pkgs, lib, ...}:
{

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  nixpkgs.config.allowUnfree = true;
  home-manager.useGlobalPkgs = true;
  home-manager.backupFileExtension = "bak";
  home-manager.users.sophia = { pkgs, ... }: {
    services.gnome-keyring.enable = true;

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
        package = pkgs.firefox-beta;
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
        # theme = "CLRS";
        extraConfig = ''
background_opacity 0.5
'';
      };
      vscode = {
        enable = true;
        package = pkgs.vscode;
        profiles.default = {
          userSettings = {
            git.confirmSync = false;
            git.enableSmartCommit = true;
            git.autofetch = true;
            git.replaceTagsWhenPull = true;
            git.autoStash = true;
            editor.cursorSmoothCaretAnimation = "on";
            "github.copilot.enable.*" = true;
            files.autoSave = "afterDelay";
            terminal.integrated.enableMultiLinePasteWarning = false;
            prohe.serverAddress = "ws://192.168.67.26:12345";
            prohe.typingWindow = 10000;
            prohe.vibrationMax = 1;
            workbench.iconTheme = "material-icon-theme";
            workbench.colorTheme = "98878c8e-9f91-4e25-930d-dd7d280d9e35";
            editor.fontFamily = "'Cascadia Code',Consolas, 'Courier New', monospace";
            terminal.integrated.stickyScroll.enabled = false;
          };
          extensions = with pkgs.vscode-extensions; [
            yzhang.markdown-all-in-one
            github.vscode-pull-request-github
            github.vscode-github-actions
            ms-vscode-remote.remote-ssh
            yoavbls.pretty-ts-errors
            github.copilot
            prisma.prisma
            pkief.material-icon-theme
            esbenp.prettier-vscode
            eamodio.gitlens
            leonardssh.vscord
            stkb.rewrap
            jnoortheen.nix-ide
            ms-vscode.cpptools
            ms-vscode.cmake-tools
            mkhl.direnv
            ms-vscode.hexeditor
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
      };
    };

    dconf.settings = {
      "org/gnome/mutter" = {
        experimental-features = ["scale-monitor-framebuffer"];
      };
      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = true;
        tap-to-click = false;
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system" "qemu+ssh://sophia@mococo/system"];
        uris = ["qemu+ssh://sophia@mococo/system" "qemu:///system"];
      };
    };
  };
}