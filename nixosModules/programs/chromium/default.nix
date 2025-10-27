{ config, lib, pkgs, ...}:
{
  options.sophrams.chromium.enable = lib.mkEnableOption "Soph Chromium";

  config = lib.mkIf config.sophrams.chromium.enable {
    environment.systemPackages = [
      # From https://github.com/hyblocker/nixfiles/blob/master/apps/browsers.nix
      (pkgs.chromium.override {
        enableWideVine = true;
        commandLineArgs = [
          "--disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
        ];
      })
    ];

    programs.chromium = {
      enable = true;
      extraOpts = {
        "BrowserSignin" = 0;
        "SyncDisabled" = true;
        "PasswordManagerEnabled" = false;
        "SpellcheckEnabled" = true;
        "SpellcheckLanguage" = [
          "en-GB"
          "de-DE"
          "nl-NL"
        ];
      };
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock origin
        "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
        "hlepfoohegkhhmjieoechaddaejaokhf" # refined github
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "gcknhkkoolaabfmlnjonogaaifnjlfnp" # FoxyProxy
      ];
    };
  };
}
