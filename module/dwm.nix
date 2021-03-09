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
			      		src = super.fetchgit {
			      			url = "https://github.com/wstrm/dwm";
			      			rev = "d4c1abe4af67cedf4a6172ff869751268e867f53";
						sha256 = "10h54zl399v2pzh1khzva9z8bzvvw4y73d66s2sk416w21rf0zc7";
			      		};
			      	});
			      	st = super.st.overrideAttrs (oldAttrs: rec {
			      		buildInputs = oldAttrs.buildInputs ++ [ super.harfbuzz ];
			      		src = super.fetchgit {
			      			url = "https://github.com/wstrm/st";
			      			rev = "1824161fb82be47bcd92e6d134f9addec0f52270";
						sha256 = "1p33by594syq4di5xqjjvyzzpn0qsjzxravz3c5r2nng321173ra";
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
