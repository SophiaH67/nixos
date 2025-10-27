{ config, lib, pkgs, ...}:
{
  options.sophrams.vrcx.enable = lib.mkEnableOption "Soph Vrcx";

  config = lib.mkIf config.sophrams.vrcx.enable {
    environment.systemPackages = [
      (pkgs.vrcx.overrideAttrs (oldAttrs: {
        postFixup = (oldAttrs.postFixup or "") + ''
          wrapProgram $out/bin/vrcx \
            --add-flags "--ozone-platform=x11"
        '';
      }))
    ];
  };
}
