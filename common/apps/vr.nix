{ config, pkgs, lib, ... }:
{
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
        # application = [
        #   pkgs.motoc
        #   "continue"
        # ];
        use-steamvr-lh = true;
        openvr-compat-path = "${pkgs.opencomposite}/lib/opencomposite";
      };
    };
  };
  home-manager.users.sophia = { pkgs, ... }: {
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
  ];
}