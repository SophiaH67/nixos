
{ config, pkgs, lib, ... }:

{
  programs.zsh.enable = true;

  users.users.sophia = {
    isNormalUser = true;
    description = "Sop";
    extraGroups = [
      "wheel"
      "dialout"
    ]
    ++ lib.optional config.networking.networkmanager.enable "networkmanager"
    ++ lib.optional config.virtualisation.docker.enable "docker"
    ++ lib.optional config.programs.adb.enable "adbusers";
    initialPassword = "";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCnikJ8VSNPM1pJQ2ylPLcyWGscM+9bFUnExJCTOjensY/yb2ONmacKlyAA6WX2LwiR24zYys8jS8SiACVo6YAC4LRaN6RwluHHS9gIF90d8lpydV9tn8NPm8N6+8K9HlYn9vguU1Yxpghcnh6KX+qfhBY3A09kRX2W0xIAu9+a7/rMCUWck7E0dfIOu1rn0r8/Jfp3M+VScpQBEv+E0Q9vT9EqqU+LgTWYt87EBNtim7FcX/9iQ3K1x6mNh5oOl7hWsRPnuEDsqLnx/MdWtng6JejzsXp/StGxdWqDVZhTYxLS8kBm92IeXEGynhQUjp8BdoRxRtoSFuoJaJxQVTAYdbnsjc+oge+5u8AlEuq2c3pObIEUZXp73+oMMhpujyfE91REAFpT1ltQJUxQh1YFuMFZhDNz02jy/c+32X/sJCKkRFKti0i/4REbfYiFPZ23QcPMgRRHAjZ4nhlrnyOCSK6vOFwrBUuIdyfVM33VUjk46riFvhxdVrOkv/dup4U= sophia@sophiah.gay"
    ];
    shell = pkgs.zsh;
  };

  home-manager.users.sophia = { pkgs, ... }: {
    home.stateVersion = "23.11";
    home.packages = with pkgs; [
      zsh-powerlevel10k
      htop
    ];

    programs = {
      atuin = {
        enable = true;
        settings = {
          sync_address = "https://sync.roboco.dev";
        };
      };

      zsh = {
        enable = true;
        initContent = ''
          [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
          eval "$(atuin init zsh)"
          alias fixlonghornpls="kubectl get pods -n longhorn-system | grep -e Error -e CrashLoopBackOff -e Unknown -e ContainerCreating | cut -d' ' -f 1 | xargs kubectl delete pod -n longhorn-system"
        '';
        plugins = [
          {
            name = "powerlevel10k";
            src = pkgs.zsh-powerlevel10k;
            file = "share/zsh-powerlevel10k/powerlevel10k.zsh-theme";
          }
        ];
        oh-my-zsh = {
          enable = true;
          plugins = [ "git" "systemd" "rsync" "kubectl" "docker" "direnv" ];
        };
      };
    };
  };

  nix.settings.trusted-users = [ "@wheel" ];
}