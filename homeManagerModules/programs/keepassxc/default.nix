{
  config,
  lib,
  ...
}:
{
  options.sophrams.keepassxc.enable = lib.mkEnableOption "Soph Keepassxc";

  config = lib.mkIf config.sophrams.keepassxc.enable {
    programs.keepassxc = {
      enable = true;
    };

    services.syncthing.settings.folders."/home/sophia/KeePassXC" = {
      id = "0k33p-2ssxc";
      devices = [
        "ayumu"
        "rikka"
      ];
      label = "Keepass XC";
    };
  };
}
