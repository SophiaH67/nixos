# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  nixpkgs.config.packageOverrides = pkgs: {
    nur = import (builtins.fetchTarball "https://github.com/nix-community/NUR/archive/master.tar.gz") {
      inherit pkgs;
    };
  };

  # Bootloader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices."luks-3a1e08da-8901-488f-8250-dd555389259a".device = "/dev/disk/by-uuid/3a1e08da-8901-488f-8250-dd555389259a";
  networking.hostName = "rina"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable networking
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_GB.UTF-8";

  i18n.extraLocaleSettings = {
    LC_ADDRESS = "nl_NL.UTF-8";
    LC_IDENTIFICATION = "nl_NL.UTF-8";
    LC_MEASUREMENT = "nl_NL.UTF-8";
    LC_MONETARY = "nl_NL.UTF-8";
    LC_NAME = "nl_NL.UTF-8";
    LC_NUMERIC = "nl_NL.UTF-8";
    LC_PAPER = "nl_NL.UTF-8";
    LC_TELEPHONE = "nl_NL.UTF-8";
    LC_TIME = "nl_NL.UTF-8";
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.xserver.displayManager.gdm.enable = false;
  services.xserver.desktopManager.gnome.enable = false;

  # Kde
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;
  services.xserver.displayManager.defaultSession = "plasmawayland";
  environment.plasma5.excludePackages = with pkgs.libsForQt5; [
    elisa
    gwenview
    okular
    khelpcenter
    konsole
    #plasma-browser-integration
    print-manager
  ];

  # Configure keymap in X11
  services.xserver = {
    layout = "us";
    xkbVariant = "";
  };

  # Configure console keymap
  console.keyMap = "us";

  # Enable CUPS to print documents.
  services.printing.enable = false;

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
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

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Sudo
  security.sudo = {
    enable = true;
    wheelNeedsPassword = false;
  };

  # Group for managing NixOS config (so I can use git)
  users.groups.nixconfig = {};

  programs.zsh.enable = true;
  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sophia = {
    isNormalUser = true;
    description = "Sophia";
    extraGroups = [ "networkmanager" "wheel" "nixconfig" ];
    shell = pkgs.zsh;
    packages = with pkgs; [
      prismlauncher
      vesktop
      google-chrome
      atuin
      kitty
      neofetch
      fluffychat
    ];
  };

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    MOZ_USE_XINPUT2 = "1";
  };

  home-manager.useGlobalPkgs = true;

  home-manager.users.sophia = { pkgs, ... }: {
    home.packages = with pkgs; [
      atool
      httpie
      zsh-powerlevel10k
      nerdfonts
    ];
    fonts.fontconfig.enable = true;

    programs = {
      git = {
        enable = true;
        userName  = "Sophia Hage";
        userEmail = "sophia@sophiah.gay";
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
	  };
        };
        profiles.sophia = {
          search.default = "DuckDuckGo";
          search.privateDefault = "DuckDuckGo";
	  search.force = true;
        };
        #nativeMessagingHosts.packages = [ pkgs.plasma5Packages.plasma-browser-integration ];
        #preferences = {
        #  "widget.use-xdg-desktop-portal.file-picker" = 1;
        #};
      };
      vscode = {
        enable = true;
	#package = pkgs.vscode-fhs;
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
            version = "0.5.2";
            sha256 = "g6JIiXfjQKQEtdXZgsQsluKuJZO0MsD1ijy+QLYE1uY=";
          }
          {
            name = "copilot";
            publisher = "github";
            version = "1.143.601";
            sha256 = "Ge/q1fAfhI5EuJFLHZqZyuPahHSgES7G0ns9FbS9vzA=";
          }
          {
            name = "copilot-chat";
            publisher = "github";
            version = "0.12.2023122001";
            sha256 = "LsDcdlw+TdkCeHxpvY9qjAWEFjl9OXU7RNV9VLVFSdg=";
          }
          {
            name = "nix-ide";
            publisher = "jnoortheen";
            version = "0.2.2";
            sha256 = "jwOM+6LnHyCkvhOTVSTUZvgx77jAg6hFCCpBqY8AxIg=";
          }
          {
            name = "prisma";
            publisher = "prisma";
            version = "5.7.1";
            sha256 = "6xtXXZCNAtYNnoiAa5gySVaVITkNceLrj8H/A8mbTXA=";
          }
          {
            name = "material-icon-theme";
            publisher = "PKief";
            version = "4.32.0";
            sha256 = "6I9/nWv449PgO1tHJbLy/wxzG6BQF6X550l3Qx0IWpw=";
          }
          {
            name = "prettier-vscode";
            publisher = "esbenp";
            version = "10.1.0";
            sha256 = "SQuf15Jq84MKBVqK6UviK04uo7gQw9yuw/WEBEXcQAc=";
          }
          {
            name = "vscode-eslint";
            publisher = "dbaeumer";
            version = "2.4.2";
            sha256 = "eIjaiVQ7PNJUtOiZlM+lw6VmW07FbMWPtY7UoedWtbw=";
          }
        ];
      };
      zsh = {
        enable = true;
        initExtra = ''
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
    # The state version is required and should stay at the version you
    # originally installed.
    home.stateVersion = "23.11";
  };


  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
     git
     gnupg
     neovim
     glfw-wayland-minecraft
     cantarell-fonts
  #  vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
  #  wget
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

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
  system.stateVersion = "23.11"; # Did you read the comment?

}
