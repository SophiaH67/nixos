{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophices.tor.enable = lib.mkEnableOption "Soph Tor";

  config = lib.mkIf config.sophices.tor.enable {
    services.tor = {
      enable = true;
      client = {
        enable = true;
      };
    };
  };
}
