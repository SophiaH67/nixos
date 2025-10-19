{ pkgs, config, ...}:
{
  users.users.sophia.packages = with pkgs; [
    vesktop
    easyeffects
    fluffychat
    signal-desktop
    thunderbird-latest-unwrapped
  ];
}