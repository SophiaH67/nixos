{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.dev.enable = lib.mkEnableOption "Soph Dev";

  config = lib.mkIf config.soph.dev.enable {
    programs.direnv.enable = true;

    boot.binfmt.emulatedSystems = [ "aarch64-linux" ];

    environment.systemPackages = with pkgs; [
      deploy-rs
      podman-compose
    ];

    sophices.docker.enable = true;
    virtualisation = {
      containers.enable = true;
      podman = {
        enable = true;
        defaultNetwork.settings.dns_enabled = true; # Required for containers under podman-compose to be able to talk to each other.
      };
    };
  };
}
