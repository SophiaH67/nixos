{ pkgs, lib, config, ...}:
let
  wallpaper-secret = if builtins.pathExists ../../secrets/wallpaper-${config.networking.hostName}.png.age
    then "wallpaper-${config.networking.hostName}.png"
    else "wallpaper-fallback.png";

  wallpaper-secret-dark = if builtins.pathExists ../../secrets/wallpaper-${config.networking.hostName}-dark.png.age
    then "wallpaper-${config.networking.hostName}-dark.png"
    else wallpaper-secret;

  wallpaper-secret-settings = {
    file = ../../secrets/${wallpaper-secret}.age;
    mode = "400";
    owner = "sophia";
  };

  wallpaper-secret-dark-settings = {
    file = ../../secrets/${wallpaper-secret-dark}.age;
    mode = "400";
    owner = "sophia";
  };
in
{
  # Gnome things
  programs.dconf.enable = true;
  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };
  hardware.pulseaudio.enable = false;

  age.secrets = if wallpaper-secret == wallpaper-secret-dark then {
    ${wallpaper-secret} = wallpaper-secret-settings;
    "face.png" = {
      file = ../../secrets/face.png.age;
      mode = "400";
      owner = "sophia";
    };
  } else {
    ${wallpaper-secret} = wallpaper-secret-settings;
    ${wallpaper-secret-dark} = wallpaper-secret-dark-settings;
    "face.png" = {
      file = ../../secrets/face.png.age;
      mode = "400";
      owner = "sophia";
    };
  };

    environment.systemPackages = with pkgs.gnomeExtensions; [
    blur-my-shell
    night-theme-switcher
  ];

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
      };

      "org/gnome/desktop/background" = {
        picture-uri = "file://${config.age.secrets.${wallpaper-secret}.path}";
        picture-uri-dark = "file://${config.age.secrets.${wallpaper-secret-dark}.path}";
      };

      # Gnome Extensions
      "org/gnome/shell" = {
        disable-user-extensions = false;
        enabled-extensions = with pkgs.gnomeExtensions; [
          blur-my-shell.extensionUuid
          night-theme-switcher.extensionUuid
        ];
        disabled-extensions = [];
        favorite-apps = [
          "code.desktop"
          "vesktop.desktop"
          "chromium-browser.desktop"
          "org.gnome.Nautilus.desktop"
        ]
          ++ lib.optionals config.programs.steam.enable [ "steam.desktop" ];
      };
      
      "org/gnome/shell/extensions/nightthemeswitcher/time" = {
        manual-schedule = true;
        nightthemeswitcher-ondemand-keybinding=[ "<Shift><Super>t" ];
      };

      "org/gnome/shell/extensions/blur-my-shell/panel" = {
        brightness=0.6;
        override-background-dynamically = true;
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
}