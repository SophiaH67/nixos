{ pkgs, config, ...}:
{
  users.users.sophia.packages = with pkgs; [
    vesktop
    easyeffects
    fluffychat
    thunderbird-latest-unwrapped
  ];
}