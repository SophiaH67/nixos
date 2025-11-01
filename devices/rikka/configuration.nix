# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  # Bootloader.
  # boot.kernelPackages = pkgs.linuxPackages_default;
  boot.loader.systemd-boot.enable = lib.mkForce false;
  
  # First, create keys with sudo sbctl create-keys
  # Then, reboot and enter setup mode (wipe all keys)
  # Finally, enroll with sudo sbctl enroll-keys --microsoft
  boot.lanzaboote = {
    enable = true;
    pkiBundle = "/var/lib/sbctl";
  };
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "rikka";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

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
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

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
  services.cloudflare-warp.enable = true;
}
