{ pkgs, config, ...}: 
{
  environment.systemPackages = with pkgs; [
    alcom
    unityhub # Unfortunately no direct unity from nixpkgs :/
  ];
}