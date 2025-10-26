{ pkgs, lib, ...}:
{
  programs.direnv.enable = true;

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

  users.users.sophia = {
    packages = with pkgs; [
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
    ];
  };
}