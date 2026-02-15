{
  networking.hostName = "hairpin";
  networking.domain = "dev.sophiah.gay";

  services.openssh.enable = true;

  users.users."7tura9h" = {
    isNormalUser = true;
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBjPFvYoD2YSwNJguumb6DJm4pLmQob257gSxgsrChaQ sophia@sophiah.gay"
      (builtins.readFile ../../secrets/id_ed25519_sk.pub)
    ];
  };
}
