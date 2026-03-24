{
  config,
  lib,
  nixos-config,
  pkgs,
  ...
}:
{
  options.soph.base.enable = lib.mkEnableOption "Soph Homemanager Base";

  config = lib.mkIf config.soph.base.enable {
    home.stateVersion = "23.11";

    sophrams.atuin.enable = true;
    sophrams.zsh.enable = true;
    sophrams.htop.enable = true;
    sophrams.git.enable = true;
    sophrams.nvim.enable = true;
    sophrams.tmux.enable = true;

    soph.vr.enable = lib.mkIf nixos-config.soph.vr.enable (lib.mkDefault true);
    soph.gaming.enable = lib.mkIf nixos-config.soph.gaming.enable (lib.mkDefault true);

    age.identityPaths = [
      "${config.home.homeDirectory}/.ssh/id_rsa"
      "${config.home.homeDirectory}/.ssh/id_ed25519"
    ];

    home.packages = with pkgs; [
      x11_ssh_askpass
      unar
      gdu
      libfido2
      kittysay
    ];
    home.sessionVariables = {
      SSH_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    };

    programs = {
      hyfetch = {
        enable = true;
        settings = {
          preset = "transgender";
          mode = "rgb";
          auto_detect_light_dark = true;
          lightness = 0.8;
          color_align = {
            mode = "horizontal";
          };
          backend = "neofetch";
          pride_month_disable = false;

        };
      };
    };

    home.file.".ssh/id_ed25519_sk.pub".source = ../../../secrets/id_ed25519_sk.pub;
    home.file.".ssh/id_ed25519_sk".source = ../../../secrets/id_ed25519_sk;
  };
}
