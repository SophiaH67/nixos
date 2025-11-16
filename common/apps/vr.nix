{ config, pkgs, lib, inputs, self, ... }:
let
  pkgs-nvidia = import inputs.nvidianixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    config.cudaSupport = true;
    overlays = [ inputs.nixpkgs-xr.overlays.default ];
  };
in
{
  imports = [ ./vr-dev.nix ];

  # Originally from https://lvra.gitlab.io/docs/fossvr/xrizer/#nixos
  # Now from https://gitlab.rxserver.net/reality-exe/nix-config/-/blob/main/modules/nix/vr/default.nix
  nixpkgs.overlays = [
    (final: prev: {
      xrizer = prev.xrizer.overrideAttrs (oldAttrs: {
        patches =
          (oldAttrs.patches or [])
          ++ [
            ./xrizer-patches/skeletal_summary.patch
            ./xrizer-patches/device_refactor2.patch
            ./xrizer-patches/generic_trackers.patch
          ];
        doCheck = false;
      });
    })
  ];
  environment.variables = {
    STEAMVR_LH_ENABLE = "1";
    XRT_OPOSITOR_COMPUTE = "1";
    WMR_HANDTRACKING = "0";
  };


  environment.systemPackages = [ pkgs.tmux pkgs.android-tools pkgs.xrizer self.packages.${pkgs.stdenv.hostPlatform.system}.soph-vr-mode ];
  sophrams.vrcx.enable = true;

  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    defaultRuntime = true;
    package = (pkgs-nvidia.wivrn.override {cudaSupport = true;}).overrideAttrs (oldAttrs: {
      cudaSupport = true;
      preFixup = oldAttrs.preFixup + ''
        wrapProgram "$out/bin/wivrn-server" \
          --prefix LD_LIBRARY_PATH : ${lib.makeLibraryPath [ pkgs.sdl2-compat pkgs.udev ]}
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
        openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
      };
    };
  };
  home-manager.users.sophia = { pkgs, ... }: {
    xdg.configFile."openvr/openvrpaths.vrpath".force = true;
    xdg.configFile."openvr/openvrpaths.vrpath".text = ''
    {
      "config" :
      [
        "~/.local/share/Steam/config"
      ],
      "external_drivers" : null,
      "jsonid" : "vrpathreg",
      "log" :
      [
        "~/.local/share/Steam/logs"
      ],
      "runtime" :
      [
        "${pkgs.opencomposite}/lib/opencomposite"
      ],
      "version" : 1
    }
  '';

    xdg.configFile."wlxoverlay/openxr_actions.json5".force = true;
    xdg.configFile."wlxoverlay/openxr_actions.json5".source = ./vr-overlaybinds.json5;
  };

  users.users.sophia.packages = with pkgs; [
    motoc
    wlx-overlay-s
    wayvr-dashboard
  ];

  # Clicking "applications" crashes in wlx-overlay-s because too many files
  # This is my attempt at fixing
  security.pam.loginLimits = [{
    domain = "*";
    type = "soft";
    item = "nofile";
    value = "8192";
  }];
}