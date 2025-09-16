{
  imports = [ ../master.nix ];

  services.ex-machina.enable = true;
  services.ex-machina.init = true;
  # networking.useDHCP = false;
  # networking.dhcpcd.enable = false;
  # networking.interfaces.eth0.ipv6.addresses = [ {
  #   address = "2a02:810d:6f83:ad00:1ac0:4dff:fed9:df52";
  #   prefixLength = 64;
  # } ];

  networking.hostName = "schwi";
  networking.domain = "ex-machina.sophiah.gay";
}