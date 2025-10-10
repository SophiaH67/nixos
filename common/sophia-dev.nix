{ pkgs, lib, ...}:
{
  programs.direnv.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
}