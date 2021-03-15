{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.neovim;
in
{
  options.modules.neovim = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    environment.variables.EDITOR = "nvim";

    home-manager.users.wstrm.programs.neovim = {
      enable = true;

      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;

      withNodeJs = true;
      withPython = true;
      withPython3 = true;

      configure = {
        customRC = ''
          let g:config_dir='~/.dotfiles/neovim/.config/nvim/'
          execute "exe 'source' '" . g:config_dir . "/init.vim'"
        '';
      };
    };
  }]);
}
