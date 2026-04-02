{ pkgs, ... }:
{
  home.packages = with pkgs; [ sesh ];

  programs.tmux = {
    enable = true;
    shell        = "${pkgs.nushell}/bin/nu";
    terminal     = "screen-256color";
    historyLimit = 1000000;
    keyMode      = "vi";
    escapeTime   = 0;
    baseIndex    = 1;
    prefix       = "C-a";
    mouse        = true;

    plugins = with pkgs.tmuxPlugins; [
      sensible
      yank
      resurrect
      continuum
      tmux-thumbs
      tmux-fzf
      fzf-tmux-url
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavor "mocha"
          set -g @catppuccin_window_status_style "rounded"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag, 󰁌 ,}"
          set -g @catppuccin_window_number_position "right"
        '';
      }
      vim-tmux-navigator
    ];

    extraConfig = ''
      # True color
      set-option -g terminal-overrides ',xterm-256color:RGB'

      # Session / window behaviour
      set -g detach-on-destroy off
      set -g set-clipboard on
      set -g status-position top
      set -g renumber-windows on
      setw -g pane-base-index 1

      # Pane borders
      set -g pane-active-border-style 'fg=magenta,bg=default'
      set -g pane-border-style 'fg=brightblack,bg=default'

      # fzf-url
      set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
      set -g @fzf-url-history-limit '2000'

      # resurrect + continuum
      set -g @continuum-restore 'on'
      set -g @resurrect-strategy-nvim 'session'

      # ── Status bar (set after catppuccin plugin runs) ─────────────────────
      set -g status-style bg=default

      set -g status-left-length 100
      set -g status-right-length 100
      set -g status-left "#{E:@catppuccin_status_session}"
      set -g status-right "#{E:@catppuccin_status_application}#{E:@catppuccin_status_date_time}#{E:@catppuccin_status_directory}"

      # ── sesh session picker (prefix + T) ──────────────────────────────────
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

      # ── Keybindings ───────────────────────────────────────────────────────
      bind ^X lock-server
      bind ^C new-window -c "$HOME"
      bind ^D detach
      bind * list-clients

      bind H previous-window
      bind L next-window

      bind r command-prompt "rename-window %%"
      bind ^R refresh-client
      bind ^A last-window
      bind ^W list-windows
      bind w list-windows
      bind z resize-pane -Z
      bind ^Z resize-pane -Z
      bind | split-window
      bind s split-window -v -c "#{pane_current_path}"
      bind ^S split-window -v -c "#{pane_current_path}"
      bind v split-window -h -c "#{pane_current_path}"
      bind ^V split-window -h -c "#{pane_current_path}"
      bind '"' choose-window
      bind h select-pane -L
      bind ^H select-pane -L
      bind j select-pane -D
      bind ^J select-pane -D
      bind k select-pane -U
      bind ^K select-pane -U
      bind l select-pane -R
      bind ^L select-pane -R
      bind -r -T prefix , resize-pane -L 20
      bind -r -T prefix . resize-pane -R 20
      bind -r -T prefix - resize-pane -D 7
      bind -r -T prefix = resize-pane -U 7
      bind : command-prompt
      bind P set pane-border-status
      bind c kill-pane
      bind x swap-pane -D
      bind S choose-session
      bind K send-keys "clear"\; send-keys "Enter"
      bind-key -T copy-mode-vi v send-keys -X begin-selection
    '';
  };
}
