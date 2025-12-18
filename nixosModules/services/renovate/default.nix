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
    age.secrets.renovate-token = {
      file = ../../../secrets/renovate-token.age;
      mode = "444";
      owner = "root";
    };
    age.secrets.renovate-key = {
      file = ../../../secrets/renovate-haizakura.id_ed25519.age;
      mode = "444";
      owner = "root";
    };
    age.secrets.renovate-gh-token = {
      file = ../../../secrets/renovate-gh-token.age;
      mode = "444";
      owner = "root";
    };

    services.renovate.enable = true;
    services.renovate = {
      credentials = {
        RENOVATE_TOKEN = config.age.secrets.renovate-token.path;
        RENOVATE_GIT_PRIVATE_KEY = config.age.secrets.renovate-key.path;
        RENOVATE_GITHUB_COM_TOKEN = config.age.secrets.renovate-gh-token.path;
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
