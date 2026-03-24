{
  config,
  lib,
  ...
}:
{
  options.sophrams.prismlauncher.enable = lib.mkEnableOption "Soph Prism Launcher";

  config = lib.mkIf config.sophrams.prismlauncher.enable {
    programs.prismlauncher = {
      enable = true;
    };

    services.syncthing.settings.folders."/home/sophia/.local/share/PrismLauncher" = {
      id = "zeory-z9mp3";
      devices = [
        "ayumu"
        "rikka"
        "mococo"
      ];
      label = "Prism Launcher";
    };
  };
}
