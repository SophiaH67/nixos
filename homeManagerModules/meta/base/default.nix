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

    soph.vr.enable = lib.mkIf nixos-config.soph.vr.enable (lib.mkDefault true);

    age.identityPaths = [ "${config.home.homeDirectory}/.ssh/id_rsa" ];

    home.packages = [ pkgs.x11_ssh_askpass ];
    home.sessionVariables = {
      SSH_ASKPASS = "${pkgs.x11_ssh_askpass}/libexec/x11-ssh-askpass";
    };

    programs.ssh = {
      enable = true;
      extraConfig = ''
        Host muccc-broken-internet
          Hostname 192.168.2.2
          Port 22
          User openfront
      '';
    };

    home.file.".ssh/id_ed25519_sk.pub".source = ../../../secrets/id_ed25519_sk.pub;
    home.file.".ssh/id_ed25519_sk".source = ../../../secrets/id_ed25519_sk;
  };
}
