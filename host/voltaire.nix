{ config, lib, pkgs, ... }:

{
  networking.hostName = "voltaire";

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
    '';

  powerManagement.cpuFreqGovernor = "ondemand";
  powerManagement.enable = true;

  services.thinkfan.enable = true;

  hardware.trackpoint.enable = true;
  hardware.tackpoint.sensitivity = 255;
}
