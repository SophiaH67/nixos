{
  config,
  lib,
  ...
}:
{
  options.sophrams.htop.enable = lib.mkEnableOption "Soph Htop";

  config = lib.mkIf config.sophrams.htop.enable {
    programs.htop = {
      enable = true;
      settings = {
        show_cpu_temperature = 1;
        show_cpu_frequency = 1;
      };
    };
  };
}
