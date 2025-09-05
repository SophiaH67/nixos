{
  networking.hostName = "moshimoshi";

  services.asterisk = {
    enable = true;
    confFiles = {
      "extensions.conf" = builtins.readFile ./asterisk/extensions.conf;
      "pjsip.conf" = builtins.readFile ./asterisk/pjsip.conf;
      "logger.conf" = builtins.readFile ./asterisk/logger.conf;
    };
  };
  systemd.services.asterisk.restartTriggers = [
    ./asterisk/extensions.conf
    ./asterisk/pjsip.conf
    ./asterisk/logger.conf
  ];
  networking.firewall.allowedUDPPorts = [ 5060 5061 ];
  networking.firewall.allowedUDPPortRanges = [ { from = 10000; to = 20000; } ];
}