{
  imports = [ ../master.nix ];

  services.ex-machina.enable = true;
  services.ex-machina.init = true;

  networking.hostName = "schwi";
  networking.domain = "ex-machina.sophiah.gay";
}