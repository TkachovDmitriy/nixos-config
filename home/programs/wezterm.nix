{ pkgs, ... }:
{
  home.packages = with pkgs; [ jetbrains-mono ];

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config  = wezterm.config_builder()

      -- Font
      config.font      = wezterm.font("JetBrains Mono")
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

      return config
    '';
  };
}
