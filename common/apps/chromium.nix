{ config, pkgs, ... }:
{
  home-manager.users.sophia.programs.chromium = {
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
}