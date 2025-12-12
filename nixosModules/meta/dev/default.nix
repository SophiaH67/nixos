{
  config,
  lib,
  ...
}:
{
  options.soph.dev.enable = lib.mkEnableOption "Soph Dev";

  config = lib.mkIf config.soph.dev.enable {
    programs.direnv.enable = true;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  };
}
