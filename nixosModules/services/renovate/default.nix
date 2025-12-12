{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophices.renovate.enable = lib.mkEnableOption "Soph Renovate";

  config = lib.mkIf config.sophices.renovate.enable {
    # -=-=- Renovate -=-=-
    age.secrets.renovate-token.file = ../../../secrets/renovate-token;
    age.secrets.renovate-haizakura-id_ed25519.file = ../../../secrets/renovate-haizakura.id_ed25519;

    services.renovate.enable = true;
    services.renovate = {
      credentials = {
        RENOVATE_TOKEN = config.age.secrets.renovate-token.file;
        RENOVATE_GIT_PRIVATE_KEY = config.age.secrets.renovate-haizakura-id_ed25519.file;
      };
      settings = {
        endpoint = "https://xn--55q89qy6p.com/";
        gitAuthor = "Haizakura <haizakura@roboco.dev>";
        platform = "forgejo";
        platformAutomerge = true;
        autodiscover = true;

        nix.enabled = true;
      };
      runtimePackages = with pkgs; [
        gnupg
        openssh
        nodejs
        yarn
      ];
    };
  };
}
