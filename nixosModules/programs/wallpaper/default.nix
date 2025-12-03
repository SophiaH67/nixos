{ config, lib, ... }:
let
  wallpaper-secret = if builtins.pathExists ../../../secrets/wallpaper-${config.networking.hostName}.png.age
    then "wallpaper-${config.networking.hostName}.png"
    else "wallpaper-fallback.png";

  wallpaper-secret-dark = if builtins.pathExists ../../../secrets/wallpaper-${config.networking.hostName}-dark.png.age
    then "wallpaper-${config.networking.hostName}-dark.png"
    else wallpaper-secret;

  wallpaper-secret-settings = {
    file = ../../../secrets/${wallpaper-secret}.age;
    mode = "400";
    owner = "sophia";
  };

  wallpaper-secret-dark-settings = {
    file = ../../../secrets/${wallpaper-secret-dark}.age;
    mode = "400";
    owner = "sophia";
  };
in
{
  options.sophrams.wallpaper.enable = lib.mkEnableOption "Soph Wallpaper";
  options.sophrams.wallpaper.file = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Wallpaper (meant for getting, not setting)";
  };
  options.sophrams.wallpaper.file-dark = lib.mkOption {
    type = lib.types.str;
    default = "";
    description = "Dark wallpaper (meant for getting, not setting)";
  };

  config = lib.mkIf config.sophrams.wallpaper.enable {
    sophrams.wallpaper.file = config.age.secrets.${wallpaper-secret}.path;
    sophrams.wallpaper.file-dark = config.age.secrets.${wallpaper-secret-dark}.path;

    age.secrets = if wallpaper-secret == wallpaper-secret-dark then {
      ${wallpaper-secret} = wallpaper-secret-settings;
      "face.png" = {
        file = ../../../secrets/face.png.age;
        mode = "400";
        owner = "sophia";
      };
    } else {
      ${wallpaper-secret} = wallpaper-secret-settings;
      ${wallpaper-secret-dark} = wallpaper-secret-dark-settings;
      "face.png" = {
        file = ../../../secrets/face.png.age;
        mode = "400";
        owner = "sophia";
      };
    };
  };
}
