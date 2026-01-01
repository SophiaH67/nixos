{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.dev.enable = lib.mkEnableOption "Soph Dev";

  config = lib.mkIf config.soph.dev.enable {
    programs.direnv.enable = true;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    environment.systemPackages = with pkgs; [ deploy-rs ];
  };
}
