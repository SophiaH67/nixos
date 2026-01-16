{
  pkgs,
  lib,
  config,
  nixos-config,
  ...
}:
{
  options.sophrams.gnome.enable = lib.mkEnableOption "Soph Gnome";

  config = lib.mkIf config.sophrams.gnome.enable {
    services.gnome-keyring.enable = true;

    dconf.settings = {
      # Gnome backend settings
      "org/gnome/mutter" = {
        experimental-features = [ "scale-monitor-framebuffer" ];
      };

      "org/gnome/desktop/peripherals/touchpad" = {
        natural-scroll = true;
        tap-to-click = false;
        disable-while-typing = false;
        two-finger-scrolling-enabled = true;
      };

      "org/gnome/desktop/peripherals/mouse" = {
        accel-profile = "flat";
      };

      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };

      # Keybinds
      "org/gnome/desktop/wm/keybindings" = {
        switch-windows = [ "<Alt>Tab" ];
        switch-windows-backward = [
          "<Shift><Alt>Tab"
          "<Alt>Above_Tab"
        ];
        switch-applications = [ ];
        switch-applications-backward = [ ];
      };

      # Gnome frontend
      "org/gnome/desktop/interface" = {
        accent-color = "pink";
        show-battery-percentage = true;
        locate-pointer = true;
        gtk-enable-primary-paste = false;
        font-antialiasing = "rgba";
        font-hinting = "full";
      };

      "org/gnome/desktop/input-sources" = {
        sources = [
          "xkb"
          "us"
        ];
        xkb-options = [
          "terminate:ctrl_alt_bksp"
          "compose:ralt"
        ];
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${nixos-config.sophrams.wallpaper.file}";
        picture-uri-dark = "file://${nixos-config.sophrams.wallpaper.file-dark}";
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
        enabled-extensions =
          with pkgs.gnomeExtensions;
          [
            blur-my-shell.extensionUuid
            night-theme-switcher.extensionUuid
          ]
          ++ lib.optionals nixos-config.sophrams.gnome.cloudflare-warp [
            pkgs.gnomeExtensions.cloudflare-warp-toggle.extensionUuid
          ];
        disabled-extensions = [ ];
        favorite-apps = [
          "code.desktop"
          "vesktop.desktop"
          "chromium-browser.desktop"
          "org.gnome.Nautilus.desktop"
        ]
        ++ lib.optionals nixos-config.sophrams.steam.enable [ "steam.desktop" ]
        ++ lib.optionals nixos-config.sophrams.signal.enable [ "signal.desktop" ];
      };

      "org/gnome/shell/extensions/nightthemeswitcher/time" = {
        manual-schedule = true;
        nightthemeswitcher-ondemand-keybinding = [ "<Shift><Super>t" ];
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness = 0.6;
        override-background-dynamically = true;
      };

      "org/gnome/tweaks" = {
        show-extensions-notice = false;
      };

      # Other apps

      ## Console
      "org/gnome/Console" = {
        theme = "auto";
      };

      ## Virt-manager
      "org/virt-manager/virt-manager/connections" = {
        autoconnect = [
          "qemu:///system"
          "qemu+ssh://sophia@mococo/system"
        ];
        uris = [
          "qemu+ssh://sophia@mococo/system"
          "qemu:///system"
        ];
      };
    };
  };
}
