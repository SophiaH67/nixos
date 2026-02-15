{ config, ... }:
{
  flavor = "grapheneos";
  device = "tegu";

  grapheneos = {
    # This setting determines which GrapheneOS release tag will be built -
    # every channel assigns a "current release" tag to each device.
    channel = "alpha";
    officialBuild = true;
  };

  apps.fdroid.enable = true;
  source.dirs."packages/modules/Virtualization".patches = [
    (builtins.fetchurl {
      url = "https://codeberg.org/cyclopentane/robotnix-configs/raw/commit/3f735e02a097b719a3584d20c58d1cbd504aeacb/phobos/0001-support-sdcard-installation-of-GNU-Linux-images-in-r.patch";
      sha256 = "sha256-cnX9TisF+CRAGdcXo846Ztwa9gO3I+hJIe/KdVUrQWY=";
    })
  ];

  apps.updater = {
    enable = true;
    url = "https://robotnix.sophiah.gay/";
  };

  bootanimation = {
    enable = true;
    logoMask = builtins.fetchurl {
      url = "https://codeberg.org/cyclopentane/robotnix-configs/raw/commit/3f735e02a097b719a3584d20c58d1cbd504aeacb/phobos/android-logo-mask.png";
      sha256 = "sha256-de+smKu8Qpyaqkwa6pGAFKrq02S4AuzsSTxwwtAA30E=";
    };
    logoShine = builtins.fetchurl {
      url = "https://codeberg.org/cyclopentane/robotnix-configs/raw/commit/3f735e02a097b719a3584d20c58d1cbd504aeacb/phobos/android-logo-shine.png";
      sha256 = "sha256-QDAO8yyYIm6NF+JzgdOdBQ5PVvwRwVIx31GCSJEE2C4=";
    };
  };

  ccache.enable = true;
  signing = {
    enable = true;
    avb.size = 2048;
  };
}
