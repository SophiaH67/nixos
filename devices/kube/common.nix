{ config, pkgs, ... }:

{
  networking.firewall.enable = true;
  environment.systemPackages = with pkgs; [
    vim
    curl
    wget
  ];

  services.k3s.enable = true;
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
}
