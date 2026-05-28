{ config, pkgs, zen-browser, claude-code-nix, system, ... }:
{
  home.username      = "td";
  home.homeDirectory = "/home/td";
  home.stateVersion  = "25.11";

  imports = [
    ./programs/starship.nix
    ./programs/cli-tools.nix
    ./programs/zoxide.nix
    ./programs/carapace.nix
    ./programs/wezterm.nix
    ./programs/tmux
    ./programs/nushell
    ./programs/claude-code.nix
    ./programs/zen-browser.nix
    ./programs/node.nix
    ./programs/zed.nix
    ./programs/atuin.nix
    ./programs/yazi.nix
    ./programs/neovim.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/default-applications/terminal" = {
      exec     = "wezterm";
      exec-arg = "";
    };
  };
}
