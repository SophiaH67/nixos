{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.dev.enable = lib.mkEnableOption "Soph Dev";

  config = lib.mkIf config.soph.dev.enable {
    home.packages = with pkgs; [
      kdePackages.kleopatra
      dbeaver-bin
      nixfmt
      dig
      file
      nmap
      lsof
      iperf
      dig
      pv
      wireshark
      wget
      kubectl
      kubevirt
      cargo
      rustc
      github-cli
    ];

    sophrams.vscode.enable = true;
    sophrams.firefox.enable = true;
  };
}
