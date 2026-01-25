{
  config,
  pkgs,
  lib,
  self,
  ...
}:
{
  options.soph.vr.enable = lib.mkEnableOption "Soph VR Things";

  config = lib.mkIf config.soph.vr.enable {
    # https://lvra.gitlab.io/docs/fossvr/xrizer/
    nixpkgs.overlays = [
      (final: prev: {
        xrizer = prev.xrizer.overrideAttrs rec {
          src = final.fetchFromGitHub {
            owner = "ImSapphire";
            repo = "xrizer";
            rev = "7339c297b665e6292ac46115cdac0d44aab196a9";
            hash = "sha256-9PS2xDGND+bC8jCLX+rsuDY4Epfwo+nkPRea/xDSYmM=";
          };

          cargoDeps = prev.rustPlatform.importCargoLock {
            lockFile = src + "/Cargo.lock";
            outputHashes = {
              "openxr-0.19.0" = "sha256-mljVBbQTq/k7zd/WcE1Sd3gibaJiZ+t7td964clWHd8=";
            };
          };
        };
      })
    ];
    environment.variables = {
      STEAMVR_LH_ENABLE = "1";
      XRT_OPOSITOR_COMPUTE = "1";
      WMR_HANDTRACKING = "0";
    };

    environment.systemPackages = [
      pkgs.tmux
      pkgs.android-tools
      pkgs.xrizer
      pkgs.oscavmgr
      self.packages.${pkgs.stdenv.hostPlatform.system}.soph-vr-mode
    ];
    sophrams.vrcx.enable = true;

    services.wivrn = {
      enable = true;
      openFirewall = true;
      autoStart = true;
      defaultRuntime = true;
      package = (pkgs.wivrn.override { cudaSupport = true; }).overrideAttrs (oldAttrs: {
        cudaSupport = true;
        preFixup = oldAttrs.preFixup + ''
          wrapProgram "$out/bin/wivrn-server" \
            --prefix LD_LIBRARY_PATH : ${
              lib.makeLibraryPath [
                pkgs.sdl2-compat
                pkgs.udev
              ]
            }
        '';
      });
      monadoEnvironment = {
        WIVRN_USE_STEAMVR_LH = "1";
        LH_DISCOVER_WAIT_MS = "6000";
      };

      config = {
        enable = true;
        json = {
          # 100 Mb/s
          bitrate = 100000000;
          encoders = [
            {
              encoder = "nvenc";
              codec = "h264";
            }
          ];
          application = [
            self.packages.${pkgs.stdenv.hostPlatform.system}.soph-vr-mode
          ];
          use-steamvr-lh = true;
          openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
        };
      };
    };

    users.users.sophia.packages = with pkgs; [
      motoc
      wayvr
    ];

    # Clicking "applications" crashes in wlx-overlay-s because too many files
    # This is my attempt at fixing
    security.pam.loginLimits = [
      {
        domain = "*";
        type = "soft";
        item = "nofile";
        value = "8192";
      }
    ];
  };
}
