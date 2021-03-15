{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.modules.dwm;
in
{
  options.modules.dwm = {
    enable = mkOption {
      type = types.bool;
      default = false;
    };
    dwmRev = mkOption {
      type = types.str;
      default = "d4c1abe4af67cedf4a6172ff869751268e867f53";
    };
    slstatusRev = mkOption {
      type = types.str;
      default = "6df7d7386ca1e0bc7ef847a213ea6a31ffda4703";
    };
    stRev = mkOption {
      type = types.str;
      default = "1824161fb82be47bcd92e6d134f9addec0f52270";
    };
  };

  config = mkIf cfg.enable (mkMerge [{
    environment.systemPackages = with pkgs; [
      autorandr
      slstatus
      dmenu
      tmux
      st
    ];

    nixpkgs.overlays = [
      (self: super: {
        dwm = super.dwm.overrideAttrs (_: rec {
          src = builtins.fetchGit {
            url = "https://github.com/wstrm/dwm";
            rev = cfg.dwmRev;
          };
        });
        st = super.st.overrideAttrs (oldAttrs: rec {
          buildInputs = oldAttrs.buildInputs ++ [ super.harfbuzz ];
          src = builtins.fetchGit {
            url = "https://github.com/wstrm/st";
            rev = cfg.stRev;
          };
        });
        slstatus = super.st.overrideAttrs (oldAttrs: rec {
          src = builtins.fetchGit {
            url = "https://github.com/wstrm/slstatus";
            rev = cfg.slstatusRev;
          };
        });
      })
    ];

    services.xserver = {
      enable = true;
      windowManager.dwm.enable = true;
      displayManager.sessionCommands = ''
        xsetroot -solid "#000000"
        slstatus &
      '';
    };

    # Control physical access to a linux computer by locking all of its virtual terminals.
    services.physlock.enable = true;
    programs.slock.enable = true;

    fonts.fonts = with pkgs; [
      jetbrains-mono
    ];
  }]);
}
