''
  # ── Status bar (set after catppuccin plugin runs) ─────────────────────
  set -g window-status-separator " "
  set -g status-style bg=default
  set -g status-left-length 100
  set -g status-right-length 100

  set -g @catppuccin_status_modules_right "directory"
  set -g @catppuccin_status_modules_left "session"
  set -g @catppuccin_status_left_separator  " "
  set -g @catppuccin_status_right_separator " "
  set -g @catppuccin_status_right_separator_inverse "no"
  set -g @catppuccin_status_fill "icon"
  set -g @catppuccin_status_connect_separator "no"
  set -g @catppuccin_directory_text "#{b:pane_current_path}"

  set -g status-left "#{E:@catppuccin_status_session}"
  set -g status-right "#{E:@catppuccin_status_directory}"
''
