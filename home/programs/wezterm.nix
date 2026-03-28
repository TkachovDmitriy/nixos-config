{ pkgs, ... }:
{
  home.packages = with pkgs; [ jetbrains-mono ];

  programs.wezterm = {
    enable = true;
    extraConfig = ''
      local wezterm = require("wezterm")
      local config  = wezterm.config_builder()

      config.font      = wezterm.font("JetBrains Mono")
      config.font_size = 13.0
      config.color_scheme                 = "Tokyo Night"
      config.window_background_opacity    = 0.95
      config.hide_tab_bar_if_only_one_tab = true
      config.default_prog = { "zsh" }
      config.window_decorations = "RESIZE"
      config.window_frame = { border_left_width = "4px", border_right_width = "4px", border_bottom_height = "4px", border_top_height = "4px" }

      config.keys = {
        { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
        { key = "d", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
      }

      return config
    '';
  };
}
