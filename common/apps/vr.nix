{ config, pkgs, lib, inputs, ... }:
let
  scriptRaw = ''#!${pkgs.bash}/bin/bash
echo $(date) > /home/sophia/lastran

tmux_run() {
  local session="$1"
  shift
  local cmd="$*"

  # Kill the session if it exists
  if ${pkgs.tmux}/bin/tmux has-session -t "$session" 2>/dev/null; then
      ${pkgs.tmux}/bin/tmux kill-session -t "$session"
  fi

  # Create a new detached session and run the command
  ${pkgs.tmux}/bin/tmux new-session -d -s "$session" "$cmd"

  echo "Tmux session '$session' started with command: $cmd"
}

tmux_run vr_calibration ${pkgs.motoc}/bin/motoc calibrate --dst LHR-E7A0B889 --src "WiVRn HMD" --continue
tmux_run vr_vrcft ${inputs.vrcft}/bin/vrchatfacetracking
tmux_run vr_overlay ${pkgs.wlx-overlay-s}/bin/wlx-overlay-s
'';
  script = lib.concatStringsSep "\\n" (lib.splitString "\n" scriptRaw);


  pkgs-nvidia = import inputs.nvidianixpkgs {
    system = "x86_64-linux";
    config.allowUnfree = true;
    config.cudaSupport = true;
    overlays = [ inputs.nixpkgs-xr.overlays.default ];
  };
in
{
  imports = [ ./vr-dev.nix ];

  systemd.tmpfiles.rules = [
    ''f+ /run/soph-vr.sh  555 root root - ${script}''
  ];

  # https://lvra.gitlab.io/docs/fossvr/xrizer/#nixos
  nixpkgs.overlays = [
    (final: prev: {
      xrizer = prev.xrizer.overrideAttrs {
        src = final.fetchFromGitHub {
          owner = "Mr-Zero88-FBT";
          repo = "xrizer";
          rev = "10ab78de413320523ac4a8660e39c598320ca75a";
          hash = "sha256-129JIdahyWa4rVPthgZD46wsq8zFOdGntUePjLUZKK8=";
        };
        doCheck = false;
        cargoDeps = pkgs.rustPlatform.importCargoLock {
          lockFile = pkgs.fetchurl {
            url = "https://raw.githubusercontent.com/Mr-Zero88-FBT/xrizer/refs/heads/experimental2/Cargo.lock";
            hash = "sha256-m+r+ffqUF267/E4juwfZaGf1OxOfbZXYc0il4VZ384U=";
          };
          outputHashes = {
            "openxr-0.19.0" = "sha256-mljVBbQTq/k7zd/WcE1Sd3gibaJiZ+t7td964clWHd8=";
          };
        };
      };
    })
  ];

  environment.systemPackages = [ pkgs.tmux pkgs.android-tools inputs.vrcft pkgs.xrizer ];
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
          pkgs.bash
          "/run/soph-vr.sh"
        ];
        use-steamvr-lh = true;
        openvr-compat-path = "${pkgs.xrizer}/lib/xrizer";
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
        "${pkgs.xrizer}/lib/xrizer"
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