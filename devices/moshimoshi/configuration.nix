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
    source = ./radio.sh;
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