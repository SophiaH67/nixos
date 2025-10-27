{ config, pkgs, ... }:
{
  home-manager.users.sophia.programs.chromium = {
    enable = true;
    # From https://github.com/hyblocker/nixfiles/blob/master/apps/browsers.nix
    package = (pkgs.chromium.override {
      enableWideVine = true;
      commandLineArgs = [
        "--disable-features=ExtensionManifestV2Unsupported,ExtensionManifestV2Disabled"
      ];
    });
    dictionaries = [
      # pkgs.hunspellDicts.tok
      pkgs.hunspellDictsChromium.en_US
    ];
    extensions = [
      { id = "cjpalhdlnbpafiamejdnhcphjbkeiagm"; }
      { id = "gppongmhjkpfnbhagpmjfkannfbllamg"; } # wappalyzer
      { id = "hlepfoohegkhhmjieoechaddaejaokhf"; } # refined github
      { id = "nngceckbapebfimnlniiiahkandclblb"; } # bitwarden
      { id = "dbepggeogbaibhgnhhndojpepiihcmeb"; } # vimium
      { id = "gcknhkkoolaabfmlnjonogaaifnjlfnp"; } # FoxyProxy
    ];
  };
}