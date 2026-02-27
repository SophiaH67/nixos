{
  flavor = "grapheneos";
  device = "tegu";
  stateVersion = "3";

  grapheneos = {
    # This setting determines which GrapheneOS release tag will be built -
    # every channel assigns a "current release" tag to each device.
    channel = "alpha";
    officialBuild = true;
  };

  ccache.enable = true;
  signing = {
    avb.size = 4096;
  };

  soph.base.enable = true;
}
