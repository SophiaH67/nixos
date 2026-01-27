{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
{
  options.sophrams.steam.enable = lib.mkEnableOption "Soph Steam";

  imports = [
    inputs.nixpkgs-xr.nixosModules.nixpkgs-xr
  ];

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

    nixpkgs.overlays = [
      (final: prev: {
        steam-devices-udev-rules = prev.steam-devices-udev-rules.overrideAttrs {
          patches = [ ./add-x52-to-steam-udev.patch ];
        };
      })
    ];
    hardware.steam-hardware.enable = true;
  };
}
