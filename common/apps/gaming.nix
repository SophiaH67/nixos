{ pkgs, config, ... }:
{
  soph.gaming.enable = true;

  users.users.sophia.packages = with pkgs; [
    ed-odyssey-materials-helper
    edmarketconnector
  ];
}
