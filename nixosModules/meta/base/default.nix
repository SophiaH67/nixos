{ config, lib, pkgs, ...}:
{
  options.soph.base.enable = lib.mkEnableOption "Soph Nixos Base";

  config = lib.mkIf config.soph.base.enable {
    # -=-=- Boot -=-=-
    boot.kernelPackages = lib.mkDefault pkgs.linuxPackages_zen;
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.systemd-boot.configurationLimit = 35;

    # -=-=- Secrets -=-=-
    age.identityPaths = [ "/etc/ssh/ssh_host_ed25519_key" ];

    # -=-=- Networking -=-=-
    networking.firewall.enable = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    networking.search = [ "ex-machina.sophiah.gay" "dev.sophiah.gay" ];
    networking.nameservers = [ "2620:fe::9#dns9.quad9.net" "9.9.9.9#dns9.quad9.net" ];
    services.resolved = {
      enable = true;
      dnssec = "true";
      domains = config.networking.search;
      fallbackDns = config.networking.nameservers;
      dnsovertls = "true";
    };

    # -=-=- Security -=-=-
    systemd.tmpfiles.settings."10-nixos-directory"."/etc/nixos".d = {
      group = "wheel";
      mode = "0774";
    };

    security.sudo = {
      enable = true;
      wheelNeedsPassword = false;
    };

    services.openssh = {
      enable = true;
      settings = {
        X11Forwarding = true;
        PrintMotd = true;
        PermitRootLogin = "no";
        PasswordAuthentication = false;
        AllowGroups = [ "wheel" "sshable" ];
      };
      allowSFTP = true;
      banner =''
  -=-=- Establishing encrypted connection... -=-=-
  [C]: Requesting Frontier Malitia administration for node ${config.networking.hostName}
  [S]: Receiving encrypted connection...
  [S]: Provide identity:
  [C]:
  '';
      #TODO: Set up a jail for failure to authenticate
    };
    users.groups.sshable = {};

    # boot.kernelParams = [
    #   "kernel.kexec_load_disabled=1"
    # ];

    environment.systemPackages = with pkgs; [
      busybox # For lots of utils (e.g. killall)
      sbctl
      hyfetch
    ];

    # -=-=- Locale -=-=-
    console.keyMap = "us";
    time.timeZone = "Europe/Berlin";
    i18n.defaultLocale = "en_GB.UTF-8";
    i18n.extraLocaleSettings = {
      LC_ADDRESS = "de_DE.UTF-8";
      LC_IDENTIFICATION = "de_DE.UTF-8";
      LC_MEASUREMENT = "de_DE.UTF-8";
      LC_MONETARY = "de_DE.UTF-8";
      LC_NAME = "de_DE.UTF-8";
      LC_NUMERIC = "de_DE.UTF-8";
      LC_PAPER = "de_DE.UTF-8";
      LC_TELEPHONE = "de_DE.UTF-8";
      LC_TIME = "de_DE.UTF-8";
      LANGUAGE = "en_GB.UTF-8";
    };


    # -=-=- Nix -=-=-
    nixpkgs.config.allowUnfree = true;
    nix.settings.experimental-features = [ "nix-command" "flakes"];
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
