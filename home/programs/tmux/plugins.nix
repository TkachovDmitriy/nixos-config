{ pkgs }:
with pkgs.tmuxPlugins; [
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
      set -g @catppuccin_window_left_separator ""
      set -g @catppuccin_window_right_separator " "
      set -g @catppuccin_window_middle_separator " █"
      set -g @catppuccin_window_status_style "rounded"
      set -g @catppuccin_window_default_fill "number"
      set -g @catppuccin_window_default_text "#W"
      set -g @catppuccin_window_default_color "#{@thm_overlay_0}"
      set -g @catppuccin_window_default_background "#{@thm_surface_0}"
      set -g @catppuccin_window_current_fill "all"
      set -g @catppuccin_window_current_text "#W#{?window_zoomed_flag,(),}"
      set -g @catppuccin_window_current_color "#{@thm_blue}"
      set -g @catppuccin_window_current_background "#{@thm_crust}"
      set -g @catppuccin_window_number_position "right"
    '';
  }
  vim-tmux-navigator
]
