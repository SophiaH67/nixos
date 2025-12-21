{
  config,
  lib,
  inputs,
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


    age.secrets."atuin-key" = {
      file = ../../../secrets/atuin-key.age;
      mode = "600";
    };

    systemd.user.tmpfiles.rules = [
      "L %h/.local/share/atuin/key - - - - %t/agenix/atuin-key" # agenix's thing is broken; should switch to sops-nix tbh lol
    ];
  };
}
