{ pkgs, ... }:
let
  initScriptContent = import ./init-script.nix { };
  tmuxPlugins       = import ./plugins.nix { inherit pkgs; };
  settings          = import ./settings.nix;
  statusbar         = import ./statusbar.nix;
  sessions          = import ./sessions.nix { tmuxInit = "$HOME/.local/bin/tmux-session-init"; };
  keybindings       = import ./keybindings.nix;
in
{
  home.packages = with pkgs; [ sesh ];

  home.file.".local/bin/tmux-session-init" = {
    text       = initScriptContent;
    executable = true;
  };

  programs.tmux = {
    enable       = true;
    shell        = "${pkgs.nushell}/bin/nu";
    terminal     = "screen-256color";
    historyLimit = 1000000;
    keyMode      = "vi";
    escapeTime   = 0;
    baseIndex    = 1;
    prefix       = "C-a";
    mouse        = true;

    plugins = tmuxPlugins;

    extraConfig = settings + statusbar + sessions + keybindings;
  };
}
