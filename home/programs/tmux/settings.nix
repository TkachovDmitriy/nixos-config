''
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
  set -g pane-border-format " #{pane_index} #{pane_current_command} "

  # fzf-url
  set -g @fzf-url-fzf-options '-p 60%,30% --prompt="   " --border-label=" Open URL "'
  set -g @fzf-url-history-limit '2000'

  # resurrect + continuum
  set -g @continuum-restore 'on'
  set -g @resurrect-strategy-nvim 'session'
''
