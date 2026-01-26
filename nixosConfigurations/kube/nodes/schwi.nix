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

  home-manager.users.sophia = {
    soph.gui.enable = true;
    sophrams.gnome.enable = true;
  };

  networking.hostName = "schwi";
  networking.domain = "ex-machina.sophiah.gay";
}
