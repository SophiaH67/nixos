{ pkgs, config, ... }:
{
  soph.gaming.enable = true;

  users.users.sophia.packages = with pkgs; [
    prismlauncher
    ed-odyssey-materials-helper
    edmarketconnector
  ];
}
