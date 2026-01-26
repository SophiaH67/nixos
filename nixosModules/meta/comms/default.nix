{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.comms.enable = lib.mkEnableOption "Soph Communication Things";

  config = lib.mkIf config.soph.comms.enable {
    sophrams.signal.enable = lib.mkDefault true;

    environment.systemPackages = with pkgs; [
      fluffychat
    ];
  };
}
