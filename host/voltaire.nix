{ config, lib, pkgs, ... }:

{
  networking.hostName = "voltaire";

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
    '';

  boot.initrd.luks.devices = [
    {
      name = "root";
      device = "/dev/sda2";
      preLVM = true;
      allowDiscards = true;
    }
  ];

  virtualisation.docker.enable = true;
}
