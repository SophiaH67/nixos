{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophrams.zsh.enable = lib.mkEnableOption "Soph Zsh";

  config = lib.mkIf config.sophrams.zsh.enable {
    programs.zsh = {
      enable = true;
      autosuggestion.enable = true;
      autosuggestion.strategy = [
        "history"
        "completion"
      ];
      syntaxHighlighting.enable = true;
      initContent = ''
        [[ ! -f ${./p10k.zsh} ]] || source ${./p10k.zsh}
        ${if config.programs.atuin.enable then "eval \"$(atuin init zsh)\"" else ""}
        alias fixlonghornpls="kubectl get pods -n longhorn-system | grep -e Error -e CrashLoopBackOff -e Unknown -e ContainerCreating | cut -d' ' -f 1 | xargs kubectl delete pod -n longhorn-system"
        alias fixkubepls="kubectl get pods -A | grep -e Error -e CrashLoopBackOff -e Unknown -e ContainerCreating | awk ' { printf \"kubectl delete pod -n %s %s\n\", \$1, \$2} ' | bash"
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
        plugins = [
          "git"
          "systemd"
          "rsync"
          "kubectl"
          "docker"
          "direnv"
        ];
      };
    };
  };
}
