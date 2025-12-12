{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophrams.firefox.enable = lib.mkEnableOption "Soph Firefox";

  config = lib.mkIf config.sophrams.firefox.enable {
    programs.firefox = {
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
  };
}
