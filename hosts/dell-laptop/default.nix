{ config, pkgs, ... }:
{

  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      ../../abilities/X/default.nix
    ];

  boot.loader.systemd-boot.enable = true;

  networking.hostName = "nixos"; # Define your hostname.
  networking.networkmanager.enable = true;

  networking.useDHCP = false;
  networking.interfaces.wlp1s0.useDHCP = true;

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable CUPS to print documents.
  services.printing.enable = true;

}
