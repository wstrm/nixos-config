{ config, pkgs, ... }:

let
  home-manager = builtins.fetchGit {
  	url = "https://github.com/rycee/home-manager.git";
  	rev = "209566c752c4428c7692c134731971193f06b37c";
	ref = "release-20.09";
  };
in
{
  nixpkgs.config.allowUnfree = true;

  imports =
    [
      ./hardware-configuration.nix
      (import "${home-manager}/nixos/default.nix")
      ./host/dirac.nix
    ];

  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };

    kernelPackages = pkgs.linuxPackagesFor pkgs.linux_latest;
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    keyMap = "us";
  };

  users.users.wstrm = {
     isNormalUser = true;
     extraGroups = [ "wheel" "network" "sys" "lp" "video" "optical" "storage" "scanner" "power" "docker" ];
     shell = "${pkgs.zsh}/bin/zsh";
  };

  environment.systemPackages = with pkgs; [
     brightnessctl
     wget
     curl
     neovim
     gitAndTools.gitFull
     pass
     spotify
     qutebrowser
     firefox
     stow
     go
  ];

  programs = {
    zsh.enable = true;
    gnupg.agent.enable = true;
  };

  security = {
	  sudo = {
		  wheelNeedsPassword = false;
	  };
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "20.09"; # Did you read the comment?
}

