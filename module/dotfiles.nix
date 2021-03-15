{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.dotfiles;
in
{
  options.modules.dotfiles = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    home-manager.users.wstrm.home.file.".dotfiles" = {
      source = builtins.fetchGit {
        url = "https://github.com/wstrm/dotfiles.git";
        rev = "8fafae02697e43b137ae27d9b106b739c5e6367e";
        ref = "master";
      };
    };
  }]);
}
