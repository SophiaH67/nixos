{
  config,
  lib,
  ...
}:
{
  options.sophrams.atuin.enable = lib.mkEnableOption "Soph Atuin";

  config = lib.mkIf config.sophrams.atuin.enable {
    programs.atuin = {
      enable = true;
      settings = {
        sync_address = "https://sync.roboco.dev";
        sync_frequency = "5m";
        sync_records = true;
        auto_sync = true;
        sync.records = true;
      };
    };
  };
}
