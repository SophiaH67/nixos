{ config, pkgs, ... }:
{
  services.wivrn = {
    enable = true;
    openFirewall = true;
    autoStart = true;
    defaultRuntime = true;

    config = {
      enable = true;
      json = {
        # 1.0x foveation scaling
        scale = 1.0;
        # 100 Mb/s
        bitrate = 100000000;
        encoders = [
          {
            encoder = "nvenc";
            codec = "h264";
            # # 1.0 x 1.0 scaling
            # width = 1.0;
            # height = 1.0;
            # offset_x = 0.0;
            # offset_y = 0.0;
          }
        ];
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
  ];
}