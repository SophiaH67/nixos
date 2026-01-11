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
            --set __NV_DISABLE_EXPLICIT_SYNC 1
        '';
      }))
      unityhub # Unfortunately no direct unity from nixpkgs :/
      # From https://gist.github.com/nil-vr/09f6ebf470701d007553cf0de7c2c3ee
      (pkgs.stdenvNoCC.mkDerivation rec {
        pname = "unity";
        version = "2022.3.22f1";
        dontFixup = true;

        unitySrc = pkgs.fetchurl {
          url = "https://download.unity3d.com/download_unity/887be4894c44/LinuxEditorInstaller/Unity-2022.3.22f1.tar.xz";
          hash = "sha256-eE//d2kFHA9p7bA52NCUMeeuQASmSh20QDcJ3biKpQY=";
        };
        androidSupportSrc = pkgs.fetchurl {
          url = "https://download.unity3d.com/download_unity/887be4894c44/MacEditorTargetInstaller/UnitySetup-Android-Support-for-Editor-2022.3.22f1.pkg";
          hash = "sha256-Vqk8HgnFsUzjLvjIhIdJTLFHpyE6UDhwR7hN7/Jjpak=";
        };
        windowsSupportSrc = pkgs.fetchurl {
          url = "https://download.unity3d.com/download_unity/887be4894c44/MacEditorTargetInstaller/UnitySetup-Windows-Mono-Support-for-Editor-2022.3.22f1.pkg";
          hash = "sha256-iBGBpsg3IwooTqQSC/y14qq5QLuQEOvftQ07iGXCBZ0=";
        };

        nativeBuildInputs = [
          pkgs.cpio
          pkgs.xarMinimal
        ];
        buildInputs = [ unityhub.fhsEnv ];

        unpackPhase = ''
                  mkdir android
          	xar -C android -xf "${androidSupportSrc}"
                  mkdir windows
          	xar -C windows -xf "${windowsSupportSrc}"
        '';

        installPhase = ''
                  # This Editor/version/Editor path helps Unity Hub recognize the version of the editor.
                  mkdir -p "$out/bin" "$out/Editor/${version}/Editor/Data/PlaybackEngines/AndroidPlayer" "$out/Editor/${version}/Editor/Data/PlaybackEngines/WindowsStandaloneSupport"

          	tar -C "$out/Editor/${version}" -xf "${unitySrc}"
          	gzip -d < android/TargetSupport.pkg.tmp/Payload | cpio -iD "$out/Editor/${version}/Editor/Data/PlaybackEngines/AndroidPlayer"
          	gzip -d < windows/TargetSupport.pkg.tmp/Payload | cpio -iD "$out/Editor/${version}/Editor/Data/PlaybackEngines/WindowsStandaloneSupport"

          	# Create unity wrapper script
                  cat > "$out/bin/unity" <<-EOF
          	#!/bin/sh
                  SDL_VIDEODRIVER=wayland
                  exec -a "$out/Editor/${version}/Editor/Unity" "${unityhub.fhsEnv}/bin/unityhub-fhs-env" "$out/Editor/${version}/Editor/Unity" "\$@"
          	EOF
          	chmod a+x "$out/bin/unity"

          	# Fix font fallback
          	cat > "$out/Editor/${version}/Editor/Data/Resources/fontsettings.txt" <<-EOF
          	English|default=Inter, IPAPGothic, Verdana, Tahoma
          	English|Inter-Regular=Inter, IPAPGothic, Verdana, Tahoma
          	English|Inter-SemiBold=Inter, IPAPGothic, Verdana, Tahoma
          	English|Inter-Small=Inter, IPAPGothic, Verdana, Tahoma
          	English|Inter-Italic=Inter, IPAPGothic, Verdana, Tahoma
          	English|Inter-SemiBoldItalic=Inter, IPAPGothic, Verdana, Tahoma
          	EOF
        '';
      })
    ];
  };
}
