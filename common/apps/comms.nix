{ pkgs, config, ...}:
{
  users.users.sophia.packages = with pkgs; [
    vesktop
    fluffychat
    signal-desktop
    thunderbird-latest-unwrapped
  ];
}