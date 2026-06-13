{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Terminal
    wezterm

    # Editors & Git
    vim
    git

    # Network
    wget
    curl

    # Dev — languages & compilers
    nodejs
    rustc
    cargo
    gcc
    pkg-config
    openssl

    # Dev — containers
    docker-compose

    # Communication
    telegram-desktop
    slack
    discord

    # GNOME
    gnome-tweaks
    gnomeExtensions.dash-to-dock
    gnomeExtensions.appindicator
  ];
}
