{ lib, ... }:
{
  imports = [ ../master.nix ];

  services.ex-machina.enable = true;
  services.ex-machina.init = true;

  networking.interfaces.br0.ipv6.addresses = [
    {
      address = "2a02:810d:6f83:ad00:acab::1";
      prefixLength = 64;
    }
  ];

  networking.interfaces.br0.ipv4.addresses = [
    {
      address = "192.168.178.211";
      prefixLength = 24;
    }
  ];

  # Schwi is TV Machine
  soph.base-gui.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
  services.displayManager.gdm.autoSuspend = false;
  home-manager.users.sophia = {
    sophrams.gnome.blur = false;
    dconf.settings."org/gnome/desktop/screensaver".lock-enabled = false;
    dconf.settings."org/gnome/settings-daemon/plugins/power".sleep-inactive-ac-type = "nothing";
  };
  users.users.sophia.extraGroups = [
    "video"
    "render"
  ];
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
  };

  networking.hostName = "schwi";
  networking.domain = "ex-machina.sophiah.gay";
}
