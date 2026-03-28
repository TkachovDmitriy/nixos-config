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
    ./modules/packages.nix
  ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  system.stateVersion = "25.11";
}
