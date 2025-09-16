{ config, pkgs, ... }:

{
  # -=-=- Boot -=-=-
  boot.kernelPackages = pkgs.linuxPackages_zen;
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 35;

  # -=-=- Networking -=-=-
  networking.networkmanager.enable = true;
  networking.firewall.enable = true;
  networking.firewall.allowedTCPPorts = [ 22 ];

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

  # boot.kernelParams = [
  #   "kernel.kexec_load_disabled=1"
  # ];

  environment.systemPackages = with pkgs; [
    busybox # For lots of utils (e.g. killall)
    sbctl
  ];

  # -=-=- Locale -=-=-
  console.keyMap = "us";
  time.timeZone = "Europe/Berlin";
  i18n.defaultLocale = "tok";
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
    LANGUAGE = "tok";
  };


  # -=-=- Nix -=-=-
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes"];
  system.stateVersion = "25.05"; # Did you read the comment?
}