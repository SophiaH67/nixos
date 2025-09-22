{ pkgs, config, ...}:
{
  imports = [ ./sounds.nix ];

  networking.hostName = "moshimoshi";

  # -=-=- Asterisk -=-=-
  services.asterisk = {
    enable = true;
    confFiles = {
      "extensions.conf" = builtins.readFile ./asterisk/extensions.conf;
      "pjsip.conf" = builtins.readFile ./asterisk/pjsip.conf;
      "logger.conf" = builtins.readFile ./asterisk/logger.conf;
    };
  };

  networking.firewall.allowedUDPPorts = [ 5060 5061 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 1024; to = 65535; } ]; # I cannot figure out how to constrain asterisk, so whatever...

  # Hardstyle radio
  environment.systemPackages = with pkgs; [
    mpg123
    ffmpeg
  ];

  environment.etc."radio.sh" = {
    text = ''#!/bin/sh
${pkgs.ffmpeg}/bin/ffmpeg -hide_banner -loglevel error -i http://listener3.mp3.tb-group.fm:80/hb.mp3 -ar 8000 -ac 1 -f mulaw - 2> /dev/null | cat'';
    mode = "0755";
  };

  # -=-=- Netboot -=-=-
  services.pixiecore = {
    enable = true;
    openFirewall = true;
    dhcpNoBind = false;
    debug = true;
    kernel = "https://boot.netboot.xyz";
  };
}