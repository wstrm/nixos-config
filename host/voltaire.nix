{ config, lib, pkgs, ... }:

{
  networking.hostName = "voltaire";

  boot.extraModprobeConfig = ''
    options thinkpad_acpi fan_control=1
    '';

  services.thinkfan.enable = true;
}
