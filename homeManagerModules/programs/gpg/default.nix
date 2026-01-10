{
  config,
  lib,
  ...
}:
{
  options.sophrams.gpg.enable = lib.mkEnableOption "Soph Gpg";

  config = lib.mkIf config.sophrams.gpg.enable {
    programs.gpg = {
      enable = true;
      mutableKeys = false;
      mutableTrust = false;
      publicKeys = [
        {
          source = builtins.fetchurl {
            url = "https://github.com/sophiaH67.gpg";
            sha256 = "sha256:t1KJpYit5Q3px9J24vGfOTSidGfAEmCclhTcC9QXBeI=";
          };
          trust = "ultimate";
        }
        {
          source = builtins.fetchurl {
            url = "https://github.com/pacistardust.gpg";
            sha256 = "sha256:qs3LYWlSEbHMYSOIbBUHQjlFtofpjUuiXK0rsU2DSRE=";
          };
          trust = "marginal";
        }
        {
          source = builtins.fetchurl {
            url = "https://github.com/fredi-68.gpg";
            sha256 = "sha256:UZavgi5kvgGO6Y5W0JZ35P9emArGDqgK/6cgNBtIsOY=";
          };
          trust = "marginal";
        }
        {
          source = builtins.fetchurl {
            url = "https://github.com/hyblocker.gpg";
            sha256 = "sha256:ROnY+TcMLMRqG7riOKb80AtDRcTeHhHfBMVBG6ahHtU=";
          };
          trust = "marginal";
        }
      ];
    };

    services = {
      gpg-agent = {
        enable = true;
        enableSshSupport = false;
        sshKeys = [ "1FB01D6AA1106525" ];
        maxCacheTtl = 300;
      };
    };
  };
}
