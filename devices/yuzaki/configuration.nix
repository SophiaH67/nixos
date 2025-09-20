# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Bootloader.
  # boot.kernelPackages = pkgs.linuxPackages_default;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  
  # First, create keys with sudo sbctl create-keys
  # Then, reboot and enter setup mode (wipe all keys)
  # Finally, enroll with sudo sbctl enroll-keys --microsoft
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "yuzaki";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

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

  # Docker shenanigans
  virtualisation.docker.enable = true;

  programs.steam.enable = true;
  programs.adb.enable = true;
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["sophia"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g
    networkmanager-openvpn
    networkmanager-vpnc
    vpnc
    openvpn
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sophia = {
    packages = with pkgs; [
      prismlauncher
      vesktop
      parsec-bin
      spotify
      filezilla
      gedit
      gparted
      bambu-studio
      fluffychat
      xorg.xeyes
      tor-browser
      krita
      kdePackages.kleopatra
      (discord.override {
        withOpenASAR = false;
        # withVencord = true; # can do this here too
      })
      signal-desktop
      obsidian
      dbeaver-bin
      nixfmt
      dig
      file
      hyfetch
      nmap
      lsof
      iperf
      dig
      pv
      wireshark
      spotify
      qpwgraph
      pwvucontrol
      plex-desktop
      thunderbird-latest-unwrapped
      wget
      kubectl
    ];
  };

  services.protonmail-bridge.enable = true;
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "sophia";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  security.pam.services.sophia.enableGnomeKeyring = true;

  home-manager.useGlobalPkgs = true;
  
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
          { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
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
            jnoortheen.nix-ide
            prisma.prisma
            pkief.material-icon-theme
            esbenp.prettier-vscode
            eamodio.gitlens
            leonardssh.vscord
            stkb.rewrap
            jnoortheen.nix-ide
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

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };

  programs.calls.enable = true;

  # List services that you want to enable:

  services.tailscale.enable = true;
  networking.nameservers = [ "100.100.100.100" "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
  # Actually managed in https://login.tailscale.com/admin/dns
  services.resolved = {
    enable = false;
    dnssec = "true";
    domains = [ "~." "ex-machina.sophiah.gay" ];
    fallbackDns = [ "1.1.1.1#one.one.one.one" "1.0.0.1#one.one.one.one" ];
    dnsovertls = "true";
  };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  networking.extraHosts = ''
10.101.8.121  wifi.bahn.de
127.0.0.1     fritz.box
# Generated from asking 172.18.0.1 on an ice
10.101.64.121 login.wifionice.de
172.18.1.110  iceportal.de
172.18.1.110  zugportal.de
172.18.1.110  www.iceportal.de
  '';

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;
}
