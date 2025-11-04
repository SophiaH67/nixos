{ pkgs, config, ...}:
{
  imports = [ ./sounds.nix ];

  networking.hostName = "moshimoshi";

  sophices.tailscale.enable = true;

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
    ffmpeg
  ];
  # Sytemd service to:
  # 1) Make a fifo for asterisk (/etc/asterisk/sounds/custom/hardstyle-radio.ulaw)
  # 2) Use ffmpeg to read from the hardstyle radio stream and output to the fifo
  systemd.services.hardstyle-radio = {
    description = "Hardstyle Radio Stream for Asterisk";
    after = [ "network.target" ];
    wants = [ "network.target" ];
    serviceConfig = {
      ExecStartPre = "${pkgs.coreutils}/bin/mkfifo /tmp/hardstyleRadio.ulaw";
      # ExecStart = "${pkgs.ffmpeg}/bin/ffmpeg -i https://listener2.mp3.tb-group.fm/hb.mp3 -ar 8000 -ac 1 -f mulaw pipe:1 > /tmp/hardstyleRadio.ulaw";
      ExecStart = "${pkgs.bash}/bin/bash -c '${pkgs.ffmpeg}/bin/ffmpeg -i https://streaming.radio.co/s95f5f4f4a/listen -ar 8000 -ac 1 -f mulaw pipe:1 > /tmp/hardstyleRadio.ulaw'";
      ExecStopPost = "${pkgs.coreutils}/bin/rm -f /tmp/hardstyleRadio.ulaw";
      Restart = "always";
      RestartSec = "10";
      User = "asterisk";
      Group = "asterisk";
    };
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