{ config, pkgs, ... }:

{
  imports =
    [
      ./devices/yuzaki/configuration.nix
    ];
}