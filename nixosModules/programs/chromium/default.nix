{
  config,
  lib,
  pkgs,
  ...
}:
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

    environment.variables = {
      BROWSER = "chromium";
    };

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
        "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
        "hlepfoohegkhhmjieoechaddaejaokhf" # refined github
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "gcknhkkoolaabfmlnjonogaaifnjlfnp" # FoxyProxy
        "eninkmbmgkpkcelmohdlgldafpkfpnaf" # Reddit Untranslate
        "mpiodijhokgodhhofbcjdecpffjipkle" # SingleFile
        "jghecgabfgfdldnmbfkhmffcabddioke" # Volume Master
      ];
    };

    environment.etc."install-me.crx".source = builtins.fetchurl {
      url = "https://github.com/dhowe/AdNauseam/releases/download/v3.26.2/adnauseam-3.26.2.chromium.crx";
      sha256 = "sha256:1b1h3djfsy1lssg1xaqxs359jm3jhlfiyr2hrgfkz59nk2q3dwix";
    };
  };
}
