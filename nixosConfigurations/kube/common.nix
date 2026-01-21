{ lib, ... }:
{
  sophices.builder.enable = true;

  soph.base.enable = true;

  nix.settings.max-jobs = lib.mkForce 1;
}
