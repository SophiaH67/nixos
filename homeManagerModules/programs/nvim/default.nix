{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.sophrams.nvim.enable = lib.mkEnableOption "Soph Neovim";

  config = lib.mkIf config.sophrams.nvim.enable {
    programs.neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      plugins = with pkgs.vimPlugins; [
        nvim-lspconfig
        nvim-cmp
      ];
    };
  };
}
