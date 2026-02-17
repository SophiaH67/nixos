{ config, lib, ... }:
{
  age.secrets."borg-meow" = {
    file = ../../secrets/borg-meow.age;
    mode = "600";
  };

  systemd.services."borgbackup-job-borg-meow".serviceConfig.ReadWritePaths = lib.mkForce [
    "/persist/borg"
  ];
  services.borgbackup.jobs.borg-meow = {
    repo = "ssh://u547736-sub1@u547736-sub1.your-storagebox.de:23/home";
    doInit = true;
    persistentTimer = true;

    compression = "auto,lzma";
    paths = [
      "/Fuwawa/photos"
    ];
    encryption = {
      mode = "repokey-blake2";
      passCommand = "cat ${config.age.secrets."borg-meow".path}";
    };

    environment = {
      BORG_RSH = "ssh -i /persist/ssh/mococo_client_ssh -o UserKnownHostsFile=${./backup-known-hosts}";
      BORG_BASE_DIR = "/persist/borg";
    };

    extraCreateArgs = [
      "--stats"
      "--checkpoint-interval"
      "600"
    ];

    startAt = "daily";
    prune.keep = {
      within = "1d";
      daily = 7;
      weekly = 4;
      monthly = 6;
    };
  };
}
