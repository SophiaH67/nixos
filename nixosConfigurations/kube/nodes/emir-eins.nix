{
  imports = [ ../master.nix ];

  services.ex-machina.enable = true;
  
  networking.interfaces.br0.ipv6.addresses = [{
    address = "2a02:810d:6f83:ad00:acab::2";
    prefixLength = 64;
  }];

  networking.hostName = "emir-eins";
  networking.domain = "ex-machina.sophiah.gay";
}