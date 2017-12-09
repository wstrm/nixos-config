{ config, lib, pkgs, ... }:

{
  networking.hostName = "hubble";

  services.xserver.videoDrivers = [ "nvidia" ];
  
  services.xserver.exportConfiguration = true;

  environment.etc = [ 
    {
      source = ./hubble-xorg-multihead.conf;
      target = "X11/xorg.conf.d/90-nvidia.conf";
    }
  ];

  nixpkgs.config = {
    slstatus = pkgs.callPackage ./pkgs/slstatus { desktop = true; };
  };
}

