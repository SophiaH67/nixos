{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.soph.dev-vr.enable = lib.mkEnableOption "Soph Dev VR";

  config = lib.mkIf config.soph.dev-vr.enable {
    home.packages = with pkgs; [
      # https://github.com/vrc-get/vrc-get/issues/1405
      (alcom.overrideAttrs (oldAttrs: {
        postFixup = (oldAttrs.postFixup or "") + ''
          wrapProgram $out/bin/ALCOM \
            --set WEBKIT_DISABLE_DMABUF_RENDERER 1
        '';
      }))
      unityhub # Unfortunately no direct unity from nixpkgs :/
    ];
  };
}
