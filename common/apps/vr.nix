{ config, pkgs, lib, ... }:
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
tmux_run vr_vrcft /home/sophia/git/VRCFaceTracking.Avalonia/result/bin/vrchatfacetracking
tmux_run vr_overlay ${pkgs.wlx-overlay-s}/bin/wlx-overlay-s
'';
  script = lib.concatStringsSep "\\n" (lib.splitString "\n" scriptRaw);
in
{
  systemd.tmpfiles.rules = [
    ''f+ /run/soph-vr.sh  555 root root - ${script}''
  ];

  environment.systemPackages = [ pkgs.tmux pkgs.android-tools ];

  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    defaultRuntime = true;
    package = (pkgs.wivrn.override {cudaSupport = true;}).overrideAttrs (oldAttrs: {
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
          "-c"
          "/run/soph-vr.sh"
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
  };

  users.users.sophia.packages = with pkgs; [
    vrcx
    motoc
    wlx-overlay-s
    wayvr-dashboard
  ];
}