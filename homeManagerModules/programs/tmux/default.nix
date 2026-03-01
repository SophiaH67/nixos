{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophrams.tmux.enable = lib.mkEnableOption "Soph Tmux";

  config = lib.mkIf config.sophrams.tmux.enable {
    programs.tmux = {
      enable = true;
      clock24 = true;
      historyLimit = 5000;
      mouse = true;
      plugins = with pkgs.tmuxPlugins; [
        better-mouse-mode
        tilish
      ];
      extraConfig = lib.mkAfter ''
        set -g @tilish-easymode on
      '';
    };
  };
}
