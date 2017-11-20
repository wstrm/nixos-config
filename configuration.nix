# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, fetchurl, ... }:

  {
    imports =
    [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
    ./host/voltaire.nix
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda2";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  environment.sessionVariables = {
    GOPATH="$HOME/Projects/go";
    PATH="$PATH:$HOME/.local/bin:$HOME/Projects/go/bin";
  };

  environment.extraInit = ''
    rm -f ~/.config/Trolltech.conf
    rm -f ~/.config/gtk-3.0/settings.ini
    export XDG_DATA_DIRS="${pkgs.arc-theme}/share:$XDG_DATA_DIRS"
    export XDG_CONFIG_DIRS="/etc/xdg:$XDG_CONFIG_DIRS"
    export GTK2_RC_FILES=$GTK_RC_FILES:${pkgs.writeText "iconrc" ''gtk-icon-theme-name="Arc-Dark"''}:${pkgs.arc-theme}/share/themes/Arc-Dark/gtk-2.0/gtkrc
    export GDK_PIXBUF_MODULE_FILE=$(echo ${pkgs.librsvg.out}/lib/gdk-pixbuf-2.0/*/loaders.cache)
    export QT_STYLE_OVERRIDE=Arc-Dark

    export XDG_CONFIG_HOME=$HOME/.config
    export XDG_DATA_HOME=$HOME/.local/share
    export XDG_CACHE_HOME=$HOME/.cache
  '';

  environment.etc."xdg/Trolltech.conf" = {
    text = ''
      [Qt]
      style=Arc-Dark
    '';
    mode = "444";
  };

  environment.etc."xdg/gtk-3.0/settings.ini" = {
    text = ''
      [Settings]
      gtk-icon-theme-name=Arc-Dark
      gtk-theme-name=Arc-Dark
    '';
    mode = "444";
  };

  environment.etc."skel/.gnupg/gpg-agent.conf" = {
    text = ''
      default-cache-ttl 7200
      max-cache-ttl 7200
    '';
    mode = "444";
  };

  networking = {
    networkmanager.enable = true;

    # Open ports in the firewall.
    # firewall.allowedTCPPorts = [ ... ];
    # firewall.allowedUDPPorts = [ ... ];
    firewall.enable = true;
  };

  fonts = {
    enableFontDir = true;
    fontconfig = {
      defaultFonts = {
        monospace = [ "Fira Mono" ];
        sansSerif = [ "Fira Sans" ];
      };
      ultimate.enable = true;
    };
    fonts = with pkgs; [
      fira
      fira-mono
    ];
  };

  # Set your time zone.
  time.timeZone = "Europe/Stockholm";

  hardware.pulseaudio.enable = true;

  programs.zsh.enable = true;

  # List packages installed in system profile. To search by name, run:
  # $ nix-env -qaP | grep wget
  environment.systemPackages = with pkgs; [
    neovim
    gitAndTools.gitFull
    sudo
    dmenu
    bc
    htop
    gnupg
    manpages
    zlib
    binutils
    nix
    scrot
    wget
    gcc
    gnumake
    p7zip
    mupdf
    mosh
    mpv
    zip
    pass
    go
    st
    dunst
    libnotify
    xsel
    dwm
    i3lock
    arc-theme
    arc-icon-theme
    qutebrowser
    firefox
    chromium
    xautolock
    oh-my-zsh
    slstatus
  ];

  services.redshift = {
    enable = true;
    latitude = "65.0";
    longitude = "22.0";
  };

  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };

  nixpkgs.config = {
    allowUnfree = true;
    packageOverrides = pkgs: {
      neovim = pkgs.neovim.override {
        vimAlias = true;
        configure = import ./pkgs/nvim.nix {
          inherit pkgs;
        };
      };
      dwm = pkgs.callPackage ./pkgs/dwm {};
      st = pkgs.callPackage ./pkgs/st {};
      slstatus = pkgs.callPackage ./pkgs/slstatus {};
    };
  };

  programs.zsh.interactiveShellInit = ''
    export ZSH=${pkgs.oh-my-zsh}/share/oh-my-zsh/

    bindkey -v # enable vi-mode

    ZSH_THEME="gentoo"
    plugins=(git golang common-aliases systemd vi-mode)

    source $ZSH/oh-my-zsh.sh
  '';

  programs.zsh.promptInit = ""; # avoid conflict with oh-my-zsh

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

  services.xserver = {
    # Enable the X11 windowing system.
    enable = true;
    layout = "se";
    xkbOptions = "eurosign:e";

    # Enable touchpad support.
    libinput.enable = true;

    # Enable the KDE Desktop Environment.
    displayManager = {
      slim.enable = true;
      slim.defaultUser = "wp";
      slim.autoLogin = true;
      sessionCommands = ''
        export _JAVA_AWT_WM_NONREPARENTING=1; # fix grey box for Java GUIs
        xautolock -time 10 -detectsleep -lockaftersleep -locker 'i3lock -c 000000 -u -f' &
        slstatus &
      '';
    };

    desktopManager.default = "none";

    windowManager = {
      dwm.enable = true;
      default = "dwm";
    };

    wacom.enable = true;
  };

  services.physlock.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.extraUsers.wp = {
    isNormalUser = true;
    uid = 1000;
    home = "/home/wp";
    description = "William Wennerström";
    extraGroups =  [ "wheel" "network" "sys" "lp" "video" "optical" "storage" "scanner" "power" ];
    shell = "${pkgs.zsh}/bin/zsh";
    isSystemUser = false;
    useDefaultShell = true;
  };

  security.sudo.enable = true;

  # This value determines the NixOS release with which your system is to be
  # compatible, in order to avoid breaking some software such as database
  # servers. You should change this only after NixOS release notes say you
  # should.
  system.stateVersion = "17.09"; # Did you read the comment?
}
