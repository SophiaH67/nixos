{
  config,
  lib,
  pkgs,
  inputs,
  self,
  ...
}:
let
  deviceKeys = import ../../../secrets/deviceKeys.nix;

  sshHostnames =
    let
      sshEnabled = builtins.filter (
        name:
        self.nixosConfigurations.${name}.config.services.openssh.enable
        && (builtins.hasAttr name deviceKeys)
      ) (builtins.attrNames self.nixosConfigurations);
    in
    map (name: self.nixosConfigurations.${name}.config.networking.hostName) sshEnabled;
in
{
  imports = [
    inputs.disko.nixosModules.disko
    inputs.nixos-generators.nixosModules.all-formats
  ];

  options.soph.base.enable = lib.mkEnableOption "Soph Nixos Base";

  config = lib.mkIf config.soph.base.enable {
    # -=-=- User -=-=-
    nix.settings.trusted-users = [ "@wheel" ];

    home-manager.extraSpecialArgs = {
      nixos-config = config;
    };

    home-manager.useGlobalPkgs = true;
    home-manager.backupFileExtension = "bak";
    home-manager.extraSpecialArgs = { inherit inputs; };
    home-manager.sharedModules = [
      ../../../homeManagerModules
      inputs.nixcord.homeModules.nixcord
      inputs.agenix.homeManagerModules.age
    ];
    home-manager.users.sophia = {
      soph.base.enable = true;
    };

    users.users.sophia = {
      isNormalUser = true;
      description = "Sop";
      packages = [ pkgs.ghostty ]; # So servers accept my TERM= variable
      extraGroups = [
        "wheel"
        "dialout"
      ]
      ++ lib.optional config.networking.networkmanager.enable "networkmanager"
      ++ lib.optional config.virtualisation.docker.enable "docker";
      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjPFvYoD2YSwNJguumb6DJm4pLmQob257gSxgsrChaQ sophia@sophiah.gay"
        (builtins.readFile ../../../secrets/id_ed25519_sk.pub)
      ];
      shell = pkgs.zsh;
    };
    programs.zsh.enable = true;

    # -=-=- Boot -=-=-
    boot.kernelPackages = lib.mkDefault (
      if pkgs.stdenv.hostPlatform.isAarch64 then pkgs.linuxPackages_latest else pkgs.linuxPackages_zen
    );
    boot.loader.systemd-boot.enable = lib.mkDefault true;
    boot.loader.systemd-boot.configurationLimit = 35;

    # -=-=- Secrets -=-=-
    age.identityPaths = [
      "/etc/ssh/ssh_host_ed25519_key"
      "/persist/ssh/ssh_host_ed25519_key"
    ];

    # -=-=- Networking -=-=-
    networking.nftables.enable = true;
    networking.firewall.enable = true;
    networking.firewall.rejectPackets = true;
    networking.firewall.allowedTCPPorts = [ 22 ];
    environment.etc."resolv.conf".text = ''
      search ex-machina.sophiah.gay dev.sophiah.gay${if config.sophices.isla.enable then " isla" else ""}
      nameserver ::1
      options edns0 trust-ad
    '';
    networking.networkmanager.dns = "none";
    services.unbound = {
      enable = true;
      settings = {
        server = {
          interface = [
            "::1"
          ];
        };
      };
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

    sophices.ssh.enable = true;

    programs.ssh.knownHosts = builtins.listToAttrs (
      map (hostName: {
        name = hostName;
        value = {
          hostNames =
            let
              targetConfig = self.nixosConfigurations.${hostName}.config;
            in
            [ targetConfig.networking.hostName ]
            ++ lib.optional targetConfig.sophices.isla.enable "${hostName}.isla"
            ++ lib.optional (targetConfig.networking.domain != null) targetConfig.networking.fqdn;
          publicKey = deviceKeys.${hostName};
        };
      }) sshHostnames
    );

    # boot.kernelParams = [
    #   "kernel.kexec_load_disabled=1"
    # ];

    environment.systemPackages = with pkgs; [
      # START: https://archlinux.org/packages/core/any/base/
      coreutils-full
      file
      findutils
      gawk
      gnugrep
      gnused
      iproute2
      iputils
      pciutils
      psmisc
      # END: https://archlinux.org/packages/core/any/base/
      tree
      sbctl
      hyfetch
      usbutils
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
    virtualisation.vmVariant = {
      virtualisation.tpm.enable = true;
      virtualisation.memorySize = 3072;
    };
    virtualisation.vmVariantWithDisko = config.virtualisation.vmVariant;

    nixpkgs.config.allowUnfree = true;
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      min-free = 100 * 1024 * 1024; # 100gb
      max-free = 200 * 1024 * 1024; # 200gb

      max-jobs = 2; # Only 2 jobs at the same time
      cores = 0; # But use all available cores
    };
    nix.optimise.automatic = true;
    nix.gc.automatic = true;
    nix.package = pkgs.lixPackageSets.stable.lix;
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
