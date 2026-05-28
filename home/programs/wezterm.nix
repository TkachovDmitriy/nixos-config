{ pkgs, ... }:
{
  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config  = wezterm.config_builder()

      -- Font
      config.font      = wezterm.font_with_fallback({
        "FiraCode Nerd Font Mono",
        { family = "Symbols Nerd Font Mono", scale = 1.2 },
      })
      config.font_size = 13.0

      config.color_scheme = "Catppuccin Mocha"

      -- Transparency (blur is handled by the GNOME compositor)
      config.window_background_opacity = 0.8
      config.text_background_opacity   = 1.0

      -- Window chrome
      config.window_decorations = "RESIZE"
      config.window_padding     = { left = 16, right = 16, top = 12, bottom = 12 }

      -- Tab bar hidden; tmux manages sessions and splits
      config.enable_tab_bar = false

      config.default_prog = { "${pkgs.nushell}/bin/nu" }

      config.initial_cols = 200
      config.initial_rows = 50

      -- Smooth cursor
      config.animation_fps        = 60
      config.cursor_blink_ease_in  = 'EaseIn'
      config.cursor_blink_ease_out = 'EaseOut'

      return config
    '';
  };
}
