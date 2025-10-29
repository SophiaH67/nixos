{ config, lib, pkgs, ...}:
{
  options.sophrams.steam.enable = lib.mkEnableOption "Soph Steam";

  config = lib.mkIf config.sophrams.steam.enable {
    programs.steam = {
      enable = true;

      extraCompatPackages = with pkgs; [
        proton-ge-bin
        proton-ge-rtsp-bin
      ];

      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
    };
  };
}
