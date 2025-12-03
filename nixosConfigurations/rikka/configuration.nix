# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:
{
  networking.hostName = "rikka";

  # Docker shenanigans
  virtualisation.docker.enable = true;

  programs.adb.enable = true;
  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = ["sophia"];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g
    networkmanager-openvpn
    networkmanager-vpnc
    vpnc
    openvpn
    cloudflare-warp
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sophia = {
    packages = with pkgs; [
      parsec-bin
      spotify
      obsidian
      plex-desktop
    ];
  };

  services.protonmail-bridge.enable = true;
  security.pam.services.sophia.enableGnomeKeyring = true;

  programs.calls.enable = true;

  # List services that you want to enable:
  sophices.tailscale.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  networking.extraHosts = ''
10.101.8.121  wifi.bahn.de
127.0.0.1     fritz.box
# Generated from asking 172.18.0.1 on an ice
10.101.64.121 login.wifionice.de
172.18.1.110  iceportal.de
172.18.1.110  zugportal.de
172.18.1.110  www.iceportal.de
172.18.1.100 filme-serien.iceportal.de
172.18.1.100 api.filme-serien.iceportal.de
172.18.1.100 assets.filme-serien.iceportal.de
  '';

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  users.users.sophiah = {
    isNormalUser = true;
    description = "Sophia Hage";
    extraGroups = [ "networkmanager" "wheel" ];
    packages = with pkgs; [
    #  thunderbird
    ];
  };

  age.secrets.secret1.file = ../../secrets/secret1.age;
  environment.etc."secret1".source = config.age.secrets.secret1.path;

  soph.drawing.enable = true;
  sophices.tor.enable = true;
  sophices.plymouth.enable = true;
  sophices.cloudflare-warp.enable = false;
  soph.secure.enable = true;
  sophrams.kodi.enable = true;

  boot.loader.systemd-boot.configurationLimit = lib.mkForce 10;

  services.hardware.bolt.enable = true;
  sophrams.niri.enable =  true;
}
