# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  inputs,
  ...
}:
{
  imports = [ inputs.nixos-hardware.nixosModules.framework-13th-gen-intel ];

  networking.hostName = "rikka";

  # Docker shenanigans
  virtualisation.docker.enable = true;

  programs.virt-manager.enable = true;
  users.groups.libvirtd.members = [ "sophia" ];
  virtualisation.libvirtd.enable = true;
  virtualisation.spiceUSBRedirection.enable = true;

  environment.systemPackages = with pkgs; [
    ntfs3g
    networkmanager-openvpn
    networkmanager-vpnc
    vpnc
    openvpn
    android-tools
    monero-gui
    # electrum
  ];

  services.protonmail-bridge.enable = true;
  security.pam.services.sophia.enableGnomeKeyring = true;

  programs.calls.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.

  networking.extraHosts = ''
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

  networking.networkmanager.dispatcherScripts = [
    {
      source = pkgs.writeText "wifi-bahn-autologin" ''
        if [ "$2" != "up" ]; then
          exit
        fi

        WIFI_NAME=$(${pkgs.networkmanager}/bin/nmcli -f 802-11-wireless.ssid con show $CONNECTION_UUID | cut -c22- | ${lib.getExe pkgs.gawk} '{$1=$1};1')
        logger "Device $DEVICE_IFACE coming up. Connected to $WIFI_NAME"

        if [ "$WIFI_NAME" == "WIFI@DB" ]; then
          logger "WIFI@DB detected. Running CNA logon!"

          ${lib.getExe pkgs.curlWithGnuTls} --connect-to wifi.bahn.de:443:185.109.152.241:443 'https://wifi.bahn.de/cna/logon' -H 'sec-ch-ua-platform: "Linux"' -H 'X-Csrf-Token: csrf' -H 'Referer: https://wifi.bahn.de/cna/' -H 'Content-type: application/json' --data-raw '{}'
          exit
        elif [ "$WIFI_NAME" == "DBLounge" ]; then
          logger "DB Lounge WiFi detected. Running logon!"

          ${lib.getExe pkgs.curlWithGnuTls} --connect-to wifi.bahn.de:443:185.109.152.241:443 'https://wifi.bahn.de/login' -H 'Content-Type: application/x-www-form-urlencoded' --data-raw 'login=oneclick'
          exit
        fi

        logger "Connected to $WIFI_NAME, not any db wifi. Ignoring..."

      '';
      type = "basic";
    }
  ];

  services.fprintd.enable = true;
  services.fprintd.tod.enable = true;
  services.fprintd.tod.driver = pkgs.libfprint-2-tod1-goodix;

  age.secrets.secret1.file = ../../secrets/secret1.age;
  environment.etc."secret1".source = config.age.secrets.secret1.path;

  soph.drawing.enable = true;
  sophices.plymouth.enable = true;
  sophices.cloudflare-warp.enable = false;
  soph.secure.enable = true;
  sophrams.kodi.enable = true;

  boot.loader.systemd-boot.configurationLimit = lib.mkForce 10;

  services.hardware.bolt.enable = true;

  sophices.renovate.enable = true;
  soph.dev.enable = true;
  soph.comms.enable = true;

  services.thermald.enable = true;

  soph.base.enable = true;
}
