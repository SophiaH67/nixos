{
  imports = [ ../master.nix ];

  services.ex-machina.enable = true;
  
  networking.interfaces.br0.ipv6.addresses = [{
    address = "2a02:810d:6f83:ad00:acab::3";
    prefixLength = 64;
  }];

  networking.hostName = "emir-zwei";
  networking.domain = "ex-machina.sophiah.gay";
}