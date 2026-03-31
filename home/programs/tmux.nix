{ pkgs, ... }:
{
  home.packages = with pkgs; [ sesh zoxide ];

  programs.tmux = {
    enable = true;
    shell  = "${pkgs.nushell}/bin/nu";
    terminal = "tmux-256color";
    historyLimit = 10000;
    keyMode = "vi";
    escapeTime = 0;
    baseIndex = 1;

    plugins = with pkgs.tmuxPlugins; [
      catppuccin
      vim-tmux-navigator
    ];

    extraConfig = ''
      # True color
      set -as terminal-features ",xterm-256color:RGB"

      # Mouse
      set -g mouse on

      # Pane index starts at 1
      setw -g pane-base-index 1

      # Renumber windows on close
      set -g renumber-windows on

      # ── Catppuccin theme ────────────────────────────────────────────────
      set -g @catppuccin_flavour "mocha"

      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_number_position "right"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_current_fill "number"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
      set -g @catppuccin_status_modules_right "directory"
      set -g @catppuccin_status_modules_left "session"
      set -g @catppuccin_status_left_separator  " "
      set -g @catppuccin_status_right_separator " "
      set -g @catppuccin_status_right_separator_inverse "no"
      set -g @catppuccin_status_fill "icon"
      set -g @catppuccin_status_connect_separator "no"
      set -g @catppuccin_directory_text "#{b:pane_current_path}"

      # ── sesh keybind (prefix + T) ────────────────────────────────────────
      bind-key T run-shell "sesh connect $(
        sesh list --icons | fzf-tmux -p 55%,60% \
          --no-sort --ansi --border-label ' sesh ' \
          --prompt '⚡  ' \
          --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
          --bind 'tab:down,btab:up' \
          --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
          --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
          --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
          --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
          --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
          --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list --icons)' \
      )"
    '';
  };
}
