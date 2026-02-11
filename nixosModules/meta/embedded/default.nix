{
  config,
  lib,
  ...
}:
{
  options.soph.embedded.enable = lib.mkEnableOption "Soph Embedded Stuff (low performance)";

  config = lib.mkIf config.soph.embedded.enable {
  };
}
