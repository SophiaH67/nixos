{ config, lib, pkgs, ...}:
{
  options.sophrams.vrcx.enable = lib.mkEnableOption "Soph Vrcx";

  config = lib.mkIf config.sophrams.vrcx.enable {
    environment.systemPackages = [
      (pkgs.vrcx.overrideAttrs (prev: {
        postFixup =
          (prev.postFixup or "")
          + (if config.hardware.nvidia.enabled then "\nwrapProgram $out/bin/vrcx --add-flags --ozone-platform=x11" else "");
      }))
    ];
  };
}
