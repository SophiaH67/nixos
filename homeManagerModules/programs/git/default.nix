{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophrams.git.enable = lib.mkEnableOption "Soph Git";

  config = lib.mkIf config.sophrams.git.enable {
    programs.git = {
      enable = true;
      userName = "Sophia Hage";
      userEmail = "sophia@sophiah.gay";
      signing = {
        key = "1FB01D6AA1106525";
        signByDefault = true;
        format = "openpgp";
        signer = lib.getExe pkgs.sequoia-chameleon-gnupg;
      };
      extraConfig = {
        safe.directory = [ "/etc/nixos" ];
        blame.ignoreRevsFile = ".git-blame-ignore-revs";
      };
      settings = {
        init.defaultBranch = "main";
        pull.rebase = true;
      };
    };
  };
}
