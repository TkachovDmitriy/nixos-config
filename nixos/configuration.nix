{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./modules/boot.nix
    ./modules/network.nix
    ./modules/locale.nix
    ./modules/desktop.nix
    ./modules/sound.nix
    ./modules/users.nix
    ./modules/docker.nix
    ./modules/virtualisation.nix
    ./modules/gaming.nix
    ./modules/packages.nix
    ./modules/caelestia
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  programs.nix-ld.enable = true;
  system.stateVersion = "25.11";
}
