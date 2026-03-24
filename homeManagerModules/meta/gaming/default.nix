{
  config,
  lib,
  ...
}:
{
  options.soph.gaming.enable = lib.mkEnableOption "Soph Gaming";

  config = lib.mkIf config.soph.gaming.enable {
    sophrams.prismlauncher.enable = lib.mkDefault true;
  };
}
