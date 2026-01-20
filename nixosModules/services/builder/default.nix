{
  config,
  lib,
  ...
}:
{
  options.sophices.builder.enable = lib.mkEnableOption "Soph Builder System";

  config = lib.mkIf config.sophices.builder.enable {
    sophices.isla.enable = true; # We only allow builds over isla

    users.users.isla-builder = {
      isSystemUser = true;
      extraGroups = [
        "isla-sshable"
      ];

      useDefaultShell = true;

      openssh.authorizedKeys.keys = [
        "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINLd+fLmg2masZl3fIUGlVAIahLoMFHA1BIZIYa4bTcq soph-builder"
      ];
    };

    users.groups.soph-builder = { };

    # https://nix.dev/tutorials/nixos/distributed-builds-setup.html#optimise-the-remote-builder-configuration
    nix = {
      nrBuildUsers = 64;
      settings = {
        trusted-users = [ "isla-builder" ];

        min-free = 100 * 1024 * 1024; # 100gb
        max-free = 200 * 1024 * 1024; # 200gb

        max-jobs = "auto";
        cores = 0;
      };
    };

    systemd.services.nix-daemon.serviceConfig = {
      MemoryAccounting = true;
      MemoryMax = "90%";
      OOMScoreAdjust = 500;
    };
  };
}
