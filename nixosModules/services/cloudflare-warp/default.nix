{ config, lib, pkgs, ...}:
{
  options.sophices.cloudflare-warp.enable = lib.mkEnableOption "Soph Cloudflare Warp";

  config = lib.mkIf config.sophices.cloudflare-warp.enable {
    services.cloudflare-warp.enable = true;
    systemd.packages = [ pkgs.cloudflare-warp ];
    systemd.targets.multi-user.wants = [ "warp-svc.service" ];

    sophrams.gnome.cloudflare-warp = true;
  };
}