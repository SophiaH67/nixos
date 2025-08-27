# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_zen;
  # boot.kernelPackages = pkgs.linuxPackages_default;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.systemd-boot.configurationLimit = 1;

  networking.hostName = "yuzaki"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";
  
  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Berlin";

  # Select internationalisation properties.
  i18n.defaultLocale = "tok";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "de_DE.UTF-8";
    LC_IDENTIFICATION = "de_DE.UTF-8";
    LC_MEASUREMENT = "de_DE.UTF-8";
    LC_MONETARY = "de_DE.UTF-8";
    LC_NAME = "de_DE.UTF-8";
    LC_NUMERIC = "de_DE.UTF-8";
    LC_PAPER = "de_DE.UTF-8";
    LC_TELEPHONE = "de_DE.UTF-8";
    LC_TIME = "de_DE.UTF-8";
    LANGUAGE = "tok";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

   # Configure console keymap
  console.keyMap = "us";


  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Docker shenanigans
  virtualisation.docker.enable = true;

  programs.zsh.enable = true;
  programs.steam.enable = true;
  programs.adb.enable = true;
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["sophia"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  systemd.tmpfiles.settings."10-nixos-directory"."/etc/nixos".d = {
    group = "wheel";
    mode = "0774";
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sophia = {
    isNormalUser = true;
    description = "Sophia";
    extraGroups = [ "networkmanager" "wheel" "docker" "adbusers" ];
    packages = with pkgs; [
      prismlauncher
      vesktop
      neofetch
      parsec-bin
      spotify
      filezilla
      gedit
      gparted
      krita
      file
      nmap
      kdePackages.kleopatra
      (discord.override {
        withOpenASAR = true;
        # withVencord = true; # can do this here too
      })
      hyfetch
      signal-desktop
      obsidian
      dbeaver-bin
      nixfmt
      dig
      knot-dns
      lsof
    ];
    shell = pkgs.zsh;
  };

  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "sophia";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  home-manager.useGlobalPkgs = true;
  
  home-manager.users.sophia = { pkgs, ... }: {
    home.packages = with pkgs; [
      atool
      httpie
      zsh-powerlevel10k
      nerd-fonts._0xproto
      nerd-fonts.droid-sans-mono
    ];
    fonts.fontconfig.enable = true;

    programs = {
      atuin = {
        enable = true;
        settings = {
          sync_address = "https://sync.roboco.dev";
        };
      };
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
      chromium = {
        enable = true;
        dictionaries = [
          # pkgs.hunspellDicts.tok
          pkgs.hunspellDictsChromium.en_US
        ];
        extensions = [
          { id = "ddkjiahejlhfcafbddmgiahcphecmpfh"; } # ublock origin (lite)
          { id = "gppongmhjkpfnbhagpmjfkannfbllamg"; } # wappalyzer
          { id = "hlepfoohegkhhmjieoechaddaejaokhf"; } # refined github
          { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
          { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; }
        ];
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
        package = (pkgs.vscode.override { isInsiders = true; }).overrideAttrs (oldAttrs: rec {
          src = (builtins.fetchTarball {
            url = "https://code.visualstudio.com/sha/download?build=insider&os=linux-x64";
            sha256 = "sha256:1h9qviihlia5s24cxh4pmgvfv0i78x0f8r8v1m60aadpxfn81wci";
          });
          version = "latest";
          buildInputs = oldAttrs.buildInputs ++ [ pkgs.krb5 ];
        });
        profiles.default = {
          userSettings = {
            git.confirmSync = false;
            "github.copilot.enable.*" = true;
            files.autoSave = "afterDelay";
            terminal.integrated.enableMultiLinePasteWarning = false;
            prohe.serverAddress = "ws://192.168.67.26:12345";
            prohe.typingWindow = 10000;
            prohe.vibrationMax = 1;
            workbench.iconTheme = "material-icon-theme";
            workbench.colorTheme = "Default Light Modern";
            git.enableSmartCommit = true;
            git.autofetch = true;
            editor.fontFamily = "CaskaydiaCove NFM Regular";
            terminal.integrated.stickyScroll.enabled = false;
          };
          extensions = with pkgs.vscode-extensions; [
            yzhang.markdown-all-in-one
            github.vscode-pull-request-github
            github.vscode-github-actions
            ms-vscode-remote.remote-ssh
          ]  ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "pretty-ts-errors";
              publisher = "yoavbls";
              version = "0.6.1";
              sha256 = "LvX21nEjgayNd9q+uXkahmdYwzfWBZOhQaF+clFUUF4=";
            }
            {
              name = "copilot";
              publisher = "github";
              version = "1.352.1715";
              sha256 = "w9ts643RDDZMMr/PyX7v7luN7MpoUn70hVV7d4ZX/tE=";
            }
            # {
            #   name = "copilot-chat";
            #   publisher = "github";
            #   version = "0.12.2023122001";
            #   sha256 = "LsDcdlw+TdkCeHxpvY9qjAWEFjl9OXU7RNV9VLVFSdg=";
            # }
            {
              name = "nix-ide";
              publisher = "jnoortheen";
              version = "0.4.22";
              sha256 = "jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=";
            }
            {
              name = "prisma";
              publisher = "prisma";
              version = "6.13.0";
              sha256 = "qx+2lKRx/4fS2xz9lBIQsTD5tcjTzow7WmYsHYyrfOw=";
            }
            {
              name = "material-icon-theme";
              publisher = "PKief";
              version = "5.25.0";
              sha256 = "sha256-jkTFfyeFJ4ygsKJj41tWDJ91XitSs2onW4ni3rMNJE8=";
            }
            {
              name = "prettier-vscode";
              publisher = "esbenp";
              version = "11.0.0";
              sha256 = "SQuf15Jq84MKBVqK6UviK04uo7gQw9yuw/WEBEXcQAc=";
            }
            {
              name = "prohe";
              publisher = "UncensorPat";
              version = "0.1.0";
              sha256 = "mq4SP+FM3rMOYf9e6lmPcxQQn2CpgN95L3J6mXlHY1s=";
            }
            {
              name = "gitlens";
              publisher = "eamodio";
              version = "2025.8.105";
              sha256 = "w9ONz+Fjjysg71qxjOqx30A4WHU2d0Ud/MD5eWDMZe0=";
            }
            {
              name = "discord-vscode";
              publisher = "icrawl";
              version = "5.9.2";
              sha256 = "43ZAwaApQBqNzq25Uy/AmkQqprU7QlgJVVimfCaiu9k=";
            }
          ];
        };
      };
      zsh = {
        enable = true;
        initContent = ''
          [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
          eval "$(atuin init zsh)"
        '';
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "systemd" "rsync" "kubectl" "docker" ];
        };
      };
    };
    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = true;
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
      };
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = ["qemu:///system"];
        uris = ["qemu:///system"];
      };
    };
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  # List services that you want to enable:

  services.openssh.enable = true;
  services.tailscale.enable = true;
  networking.nameservers = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  services.resolved = {
    enable = false;
    dnssec = "true";
    domains = [ "~." ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "25.05"; # Did you read the comment?

  nix.settings.experimental-features = [ "nix-command" "flakes"];
}
