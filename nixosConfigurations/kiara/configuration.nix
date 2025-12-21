{ lib, ... }:
{
  networking.hostName = "kiara";
  networking.domain = "dev.sophiah.gay";

  home-manager.users.sophia = {
    sophrams.atuin.enable = lib.mkForce false;
  };
}
