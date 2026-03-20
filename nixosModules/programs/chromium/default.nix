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
        ManagedBookmarks = [
          {
            toplevel_name = "Awruff wruff :3";
          }
          # Soph Stuff
          {
            name = "公民身份识别系统";
            url = "https://xn--15qt0w.xn--55q89qy6p.com/settings/apps";
          }
          {
            name = "源控";
            url = "https://xn--55q89qy6p.com/";
          }
          {
            name = "国内公民规划系统";
            url = "https://xn--wbrs17k.xn--55q89qy6p.com/";
          }
          # Misc
          {
            name = "Fedi";
            url = "https://chaos.social";
          }
          {
            name = "Yuri";
            url = "https://twitter.com/";
          }
        ];
        BookmarkBarEnabled = true;

        # https://github.com/wimpysworld/nix-config/blob/92fcaeef7a87b608f7e041522d4627f31a8e6086/nixos/_mixins/desktop/apps/web-browsers/martin.nix#L35
        "HomePageLocation" = "https://kagi.com";
        "NewTabPageLocation" = "https://kagi.com";
      };
      defaultSearchProviderEnabled = true;
      defaultSearchProviderSuggestURL = "https://kagi.com/api/autosuggest?q={searchTerms}";
      defaultSearchProviderSearchURL = "https://kagi.com/search?q={searchTerms}";
      extensions = [
        "cjpalhdlnbpafiamejdnhcphjbkeiagm" # Ublock origin
        "gppongmhjkpfnbhagpmjfkannfbllamg" # wappalyzer
        "hlepfoohegkhhmjieoechaddaejaokhf" # refined github
        "nngceckbapebfimnlniiiahkandclblb" # bitwarden
        "dbepggeogbaibhgnhhndojpepiihcmeb" # vimium
        "gcknhkkoolaabfmlnjonogaaifnjlfnp" # FoxyProxy
        "eninkmbmgkpkcelmohdlgldafpkfpnaf" # Reddit Untranslate
        "mpiodijhokgodhhofbcjdecpffjipkle" # SingleFile
        "jghecgabfgfdldnmbfkhmffcabddioke" # Volume Master
        "cdglnehniifkbagbbombnjghhcihifij" # Kagi Extension
        "alblebhaoakdgapamjdifdfnaicpnklm" # Kagi Translate
      ];
    };
  };
}
