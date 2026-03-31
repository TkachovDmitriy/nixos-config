{ config, pkgs, zen-browser, claude-code-nix, system, ... }:
{
  home.username      = "td";
  home.homeDirectory = "/home/td";
  home.stateVersion  = "25.11";

  imports = [
    ./programs/wezterm.nix
    ./programs/tmux.nix
    ./programs/zsh
    ./programs/nushell
    ./programs/claude-code.nix
    ./programs/zen-browser.nix
    ./programs/node.nix
    ./programs/zed.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/default-applications/terminal" = {
      exec     = "wezterm";
      exec-arg = "";
    };
  };
}
