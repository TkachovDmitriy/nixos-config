{ config, pkgs, zen-browser, claude-code-nix, hunk, system, ... }:
{
  home.username      = "td";
  home.homeDirectory = "/home/td";
  home.stateVersion  = "25.11";

  imports = [
    ./programs/cli-tools.nix
    ./programs/zoxide.nix
    ./programs/carapace.nix
    ./programs/wezterm.nix
    ./programs/tmux.nix
    ./programs/zsh
    ./programs/nushell
    ./programs/claude-code.nix
    ./programs/codex.nix
    # ./programs/hunk.nix  # temporarily disabled: bun2nix evaluates x86_64-darwin, which nixpkgs 26.11 dropped
    ./programs/zen-browser.nix
    ./programs/node.nix
    ./programs/zed.nix
    ./programs/herdr.nix
  ];

  dconf.settings = {
    "org/gnome/desktop/default-applications/terminal" = {
      exec     = "wezterm";
      exec-arg = "";
    };
  };
}
