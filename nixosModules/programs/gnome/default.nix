{ pkgs, lib, config, ...}:
{


  options.sophrams.gnome.enable = lib.mkEnableOption "Soph Gnome";
  options.sophrams.gnome.autoLogin = lib.mkOption {
    type = lib.types.str;
    default = false;
    description = "Auto login user";
  };
  options.sophrams.gnome.cloudflare-warp = lib.mkOption {
    type = lib.types.bool;
    default = false;
    description = "Enable warp extensions";
  };

  config = lib.mkIf config.sophrams.gnome.enable {
    sophrams.wallpaper.enable = true;
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    services.displayManager.autoLogin.user = config.sophrams.gnome.autoLogin;
    services.gnome.sushi.enable = true;

    # Attempt to unlock gnome keyring after FDE unlock, should fail silently
    security.pam.services."sophia".enableGnomeKeyring = config.services.displayManager.autoLogin.enable;

    programs.dconf.enable = true;

    environment.systemPackages = with pkgs.gnomeExtensions; [
      blur-my-shell
      night-theme-switcher
    ]
      ++ lib.optionals config.sophrams.gnome.cloudflare-warp [ pkgs.gnomeExtensions.cloudflare-warp-toggle ];

    # Gnome Face Icon - https://discourse.nixos.org/t/setting-the-user-profile-image-under-gnome/36233/10
    systemd.tmpfiles.rules = [
      "f+ /var/lib/AccountsService/users/sophia  0600 root root - [User]\\nIcon=/var/lib/AccountsService/icons/sophia\\n"
      "L+ /var/lib/AccountsService/icons/sophia  - - - - ${config.age.secrets."face.png".path}"
    ];

    # Some programs need SUID wrappers, can be configured further or are
    # started in user sessions.
    # programs.mtr.enable = true;
    programs.gnupg.agent = {
      enable = true;
      enableSSHSupport = false;
    };

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    services.pulseaudio.enable = false;

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    home-manager.users.sophia = { pkgs, ... }: {
      services.gnome-keyring.enable = true;

      dconf.settings = {
        # Gnome backend settings
        "org/gnome/mutter" = {
          experimental-features = ["scale-monitor-framebuffer"];
        };

        "org/gnome/desktop/peripherals/touchpad" = {
          natural-scroll = true;
          tap-to-click = false;
          disable-while-typing = false;
        };

        "org/gnome/desktop/wm/preferences" = {
          button-layout= "appmenu:minimize,maximize,close";
        };

        # Keybinds
        "org/gnome/desktop/wm/keybindings" = {
          switch-windows = ["<Alt>Tab"];
          switch-windows-backward = ["<Shift><Alt>Tab" "<Alt>Above_Tab"];
          switch-applications = [];
          switch-applications-backward = [];
        };

        # Gnome frontend
        "org/gnome/desktop/interface" = {
          accent-color = "pink";
          show-battery-percentage = true;
          locate-pointer=true;
          gtk-enable-primary-paste = false;
        };

        "org/gnome/desktop/background" = {
          picture-uri = "file://${config.sophrams.wallpaper.file}";
          picture-uri-dark = "file://${config.sophrams.wallpaper.file-dark}";
        };

        "org/gnome/settings-daemon/plugins/power" = {
          power-button-action = "interactive";
        };

        "org/gnome/settings-daemon/plugins/housekeeping" = {
          donation-reminder-enabled = false;
        };

        # Gnome Extensions
        "org/gnome/shell" = {
          disable-user-extensions = false;
          enabled-extensions = with pkgs.gnomeExtensions; [
            blur-my-shell.extensionUuid
            night-theme-switcher.extensionUuid
            cloudflare-warp-toggle.extensionUuid
          ]
            ++ lib.optionals config.sophrams.gnome.cloudflare-warp [ pkgs.gnomeExtensions.cloudflare-warp-toggle.extensionUuid ];
          disabled-extensions = [];
          favorite-apps = [
            "code.desktop"
            "vesktop.desktop"
            "chromium-browser.desktop"
            "org.gnome.Nautilus.desktop"
          ]
            ++ lib.optionals config.sophrams.steam.enable [ "steam.desktop" ]
            ++ lib.optionals config.sophrams.signal.enable [ "signal.desktop" ];
        };
        
        "org/gnome/shell/extensions/nightthemeswitcher/time" = {
          manual-schedule = true;
          nightthemeswitcher-ondemand-keybinding=[ "<Shift><Super>t" ];
        };

        "org/gnome/shell/extensions/blur-my-shell/panel" = {
          brightness=0.6;
          override-background-dynamically = true;
        };

        "org/gnome/tweaks" = {
          show-extensions-notice=false;
        };

        # Other apps

        ## Console
        "org/gnome/Console" = {
          theme = "auto";
        };

        ## Virt-manager
        "org/virt-manager/virt-manager/connections" = {
          autoconnect = ["qemu:///system" "qemu+ssh://sophia@mococo/system"];
          uris = ["qemu+ssh://sophia@mococo/system" "qemu:///system"];
        };
      };
    };
  };
}
