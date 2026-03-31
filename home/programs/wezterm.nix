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

      -- Tab bar
      config.use_fancy_tab_bar          = true
      config.hide_tab_bar_if_only_one_tab = false
      config.tab_bar_at_bottom          = false
      config.tab_max_width              = 32

      config.default_prog = { "${pkgs.nushell}/bin/nu" }

      config.keys = {
        { key = "t", mods = "CTRL|SHIFT", action = wezterm.action.SpawnTab "CurrentPaneDomain" },
        { key = "d", mods = "CTRL|SHIFT", action = wezterm.action.SplitHorizontal { domain = "CurrentPaneDomain" } },
      }

      return config
    '';
  };
}
