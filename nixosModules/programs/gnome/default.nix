{
  pkgs,
  lib,
  config,
  ...
}:
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
    services.desktopManager.gnome.enable = true;
    services.displayManager.gdm.enable = true;
    services.displayManager.autoLogin.user = config.sophrams.gnome.autoLogin;
    services.gnome.sushi.enable = true;
    services.gnome.gnome-online-accounts.enable = true;

    # Attempt to unlock gnome keyring after FDE unlock, should fail silently
    security.pam.services."sophia".enableGnomeKeyring = config.services.displayManager.autoLogin.enable;

    programs.dconf.enable = true;

    environment.systemPackages =
      with pkgs.gnomeExtensions;
      [
        blur-my-shell
        night-theme-switcher
      ]
      ++ lib.optionals config.sophrams.gnome.cloudflare-warp [
        pkgs.gnomeExtensions.cloudflare-warp-toggle
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

    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };
  };
}
