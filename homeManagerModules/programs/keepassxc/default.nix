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
  };
}
