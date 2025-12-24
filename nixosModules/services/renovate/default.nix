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
      schedule = "hourly";
      settings = {
        endpoint = "https://xn--55q89qy6p.com/";
        gitAuthor = "Haizakura <haizakura@roboco.dev>";
        platform = "forgejo";
        platformAutomerge = true;
        autodiscover = true;

        packageRules = [
          {
            matchUpdateTypes = [
              "minor"
              "patch"
            ];
            matchCurrentVersion = "!/^0/";
            automerge = true;
          }
        ];

        nix.enabled = true;
        lockFileMaintenance.enabled = true;
        lockFileMaintenance.automerge = true;
        lockFileMaintenance.schedule = [ "* * * * *" ];
        osvVulnerabilityAlerts = true;

        # Recommended defaults from https://github.com/NuschtOS/nixos-modules/blob/db6f2a33500dadb81020b6e5d4281b4820d1b862/modules/renovate.nix
        cachePrivatePackages = true;
        configMigration = true;
        optimizeForDisabled = true;
        persistRepoData = true;
        repositoryCache = "enabled";
      };
      runtimePackages = with pkgs; [
        gnupg
        openssh
        nodejs
        yarn
        config.nix.package
      ];
    };
  };
}
