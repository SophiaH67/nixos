{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.vr.enable = lib.mkEnableOption "Soph VR Things";

  config = lib.mkIf config.soph.vr.enable { };
}
