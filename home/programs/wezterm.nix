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

      -- Hyprland handles moving, resizing and closing tiled windows.
      config.window_decorations = "NONE"
      config.window_padding     = { left = 16, right = 16, top = 12, bottom = 12 }

      -- Tab bar hidden; tmux manages sessions and splits
      config.enable_tab_bar = false

      config.default_prog = { "${pkgs.nushell}/bin/nu" }

      config.initial_cols = 200
      config.initial_rows = 50

      -- Link handling
      config.hyperlink_rules = wezterm.default_hyperlink_rules()

      config.keys = {
        -- Ctrl+Shift+U — select a URL and open it in the browser
        {
          key = "u",
          mods = "CTRL|SHIFT",
          action = wezterm.action.QuickSelectArgs({
            label = "open url",
            patterns = { "https?://\\S+" },
            action = wezterm.action_callback(function(window, pane)
              local url = window:get_selection_text_for_pane(pane)
              if url ~= "" then
                wezterm.open_with(url)
              end
            end),
          }),
        },
        -- Ctrl+Shift+Y — select a URL and copy it to the clipboard
        {
          key = "y",
          mods = "CTRL|SHIFT",
          action = wezterm.action.QuickSelectArgs({
            label = "copy url",
            patterns = { "https?://\\S+" },
            action = wezterm.action_callback(function(window, pane)
              local url = window:get_selection_text_for_pane(pane)
              if url ~= "" then
                window:copy_to_clipboard(url)
              end
            end),
          }),
        },
      }

      return config
    '';
  };
}
