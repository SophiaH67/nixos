{ pkgs, config, ...}:
{
  soph.gaming.enable = true;

  users.users.sophia.packages = with pkgs; [
    prismlauncher
  ];

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
}