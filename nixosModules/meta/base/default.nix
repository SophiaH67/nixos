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
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnikJ8VSNPM1pJQ2ylPLcyWGscM+9bFUnExJCTOjensY/yb2ONmacKlyAA6WX2LwiR24zYys8jS8SiACVo6YAC4LRaN6RwluHHS9gIF90d8lpydV9tn8NPm8N6+8K9HlYn9vguU1Yxpghcnh6KX+qfhBY3A09kRX2W0xIAu9+a7/rMCUWck7E0dfIOu1rn0r8/Jfp3M+VScpQBEv+E0Q9vT9EqqU+LgTWYt87EBNtim7FcX/9iQ3K1x6mNh5oOl7hWsRPnuEDsqLnx/MdWtng6JejzsXp/StGxdWqDVZhTYxLS8kBm92IeXEGynhQUjp8BdoRxRtoSFuoJaJxQVTAYdbnsjc+oge+5u8AlEuq2c3pObIEUZXp73+oMMhpujyfE91REAFpT1ltQJUxQh1YFuMFZhDNz02jy/c+32X/sJCKkRFKti0i/4REbfYiFPZ23QcPMgRRHAjZ4nhlrnyOCSK6vOFwrBUuIdyfVM33VUjk46riFvhxdVrOkv/dup4U= sophia@sophiah.gay"
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
    networking.search = [
      "ex-machina.sophiah.gay"
      "dev.sophiah.gay"
    ];
    networking.nameservers = [
      "::1"
    ];
    networking.networkmanager.dns = "none";
    services.stubby = {
      enable = true;
      settings = pkgs.stubby.passthru.settingsExample // {
        upstream_recursive_servers = [
          {
            address_data = "2620:fe::10";
            tls_auth_name = "dns.quad9.net";
            tls_pubkey_pinset = [
              {
                digest = "sha256";
                value = "i2kObfz0qIKCGNWt7MjBUeSrh0Dyjb0/zWINImZES+I=";
              }
            ];
          }
          {
            address_data = "9.9.9.10";
            tls_auth_name = "dns.quad9.net";
            tls_pubkey_pinset = [
              {
                digest = "sha256";
                value = "i2kObfz0qIKCGNWt7MjBUeSrh0Dyjb0/zWINImZES+I=";
              }
            ];
          }
        ];
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
    nix.settings.experimental-features = [
      "nix-command"
      "flakes"
    ];
    nix.optimise.automatic = true;
    nix.gc.automatic = true;
    nix.package = pkgs.lixPackageSets.stable.lix;
    system.stateVersion = "25.05"; # Did you read the comment?
  };
}
