{
  virtualisation.oci-containers.containers."syncthing-syncthing" = {
    image = "lscr.io/linuxserver/syncthing:latest";
    environment = {
      "PGID" = "1000";
      "PUID" = "1000";
      "TZ" = "Europe/Amsterdam";
    };
    volumes = [
      "/Fuwawa/appdata/sophia-syncthing/:/config:rw"
      "/Fuwawa/config/cockroach:/sync/cockroach:rw"
      "/Fuwawa/home/sophia/sync:/sync:rw"
    ];
    ports = [
      "8384:8384/tcp"
      "59500:59500/tcp"
      "59500:59500/udp"
    ];
  };
}