# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

{
  imports =
    [
      ../../common/apps/chromium.nix
    ];

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

  networking.hostName = "yuzaki";
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME Desktop Environment.
  services.desktopManager.gnome.enable = true;
  services.displayManager.gdm.enable = true;

  # Enable sound with pipewire.
  services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    #jack.enable = true;

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };

  # Docker shenanigans
  virtualisation.docker.enable = true;

  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    localNetworkGameTransfers.openFirewall = true;
  };
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
      prismlauncher
      vesktop
      parsec-bin
      spotify
      filezilla
      gedit
      gparted
      fluffychat
      xorg.xeyes
      tor-browser
      krita
      kdePackages.kleopatra
      (discord.override {
        withOpenASAR = false;
        # withVencord = true; # can do this here too
      })
      signal-desktop
      obsidian
      dbeaver-bin
      nixfmt
      dig
      file
      hyfetch
      nmap
      lsof
      iperf
      dig
      pv
      wireshark
      spotify
      qpwgraph
      pwvucontrol
      plex-desktop
      thunderbird-latest-unwrapped
      wget
      kubectl
      kubevirt
    ];
  };

  services.protonmail-bridge.enable = true;
  # Enable automatic login for the user.
  services.displayManager.autoLogin.enable = true;
  services.displayManager.autoLogin.user = "sophia";

  # Workaround for GNOME autologin: https://github.com/NixOS/nixpkgs/issues/103746#issuecomment-945091229
  systemd.services."getty@tty1".enable = false;
  systemd.services."autovt@tty1".enable = false;

  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };

  security.pam.services.sophia.enableGnomeKeyring = true;

  programs.calls.enable = true;

  # List services that you want to enable:
  services.tailscale.enable = true;

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
}
