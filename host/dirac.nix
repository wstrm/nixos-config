{ config, lib, pkgs, ... }:

{
  imports =
    [
	../module/dwm.nix
    ];

  modules.dwm.enable = true;

  boot.kernelModules = [ "udl" ];
  boot.extraModprobeConfig = "options thinkpad_acpi fan_control=1";

  boot.initrd.luks.devices = {
    root = {
      device = "/dev/disk/by-uuid/8d9f6740-0ad8-4374-82a0-57aad948c7bb";
      preLVM = true;
    };
  };

  virtualisation.docker.enable = true;

  services = {
    xserver = {
      enable = true;

      desktopManager.gnome3.enable = true;
      displayManager = {
        gdm.enable = true;
        defaultSession = "none+dwm";
	sessionCommands = ''
	  ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 1 0
	  ${lib.getBin pkgs.xorg.xrandr}/bin/xrandr --setprovideroutputsource 2 0
	'';
      };

      videoDrivers = [ "displaylink" "modesetting" ];

      # Configure keymap in X11
      layout = "us";
      xkbVariant = "altgr-intl";
      xkbOptions = "caps:ctrl_modifier";

      # Enable touchpad support.
      libinput.enable = true;
      wacom.enable = true;
    };
  

    # Enable CUPS to print documents.
    printing.enable = true;
  };

  networking = {
    hostName = "dirac";

    networkmanager.enable = true;

    interfaces = {
      enp0s31f6.useDHCP = true;
      wlp0s20f3.useDHCP = true;
    };

    firewall.enable = true;
    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
  };

  hardware = {
    pulseaudio = {
      enable = true;
      package = pkgs.pulseaudioFull;
    };

    opengl.enable = true;

    bluetooth.enable = true;
    bluetooth.package = pkgs.bluezFull;

    enableAllFirmware = true;
  };

  sound = {
    enable = true;
    mediaKeys = {
      enable = true;
    };
  };
}
