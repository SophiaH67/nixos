{
  config,
  lib,
  ...
}:
{
  options.sophrams.ghostty.enable = lib.mkEnableOption "Soph Ghostty";

  config = lib.mkIf config.sophrams.ghostty.enable {
    programs.ghostty = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        theme = "light:Bluloco Light,dark:Bluloco Dark";
      };
    };
  };
}
