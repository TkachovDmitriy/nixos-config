{ herdr, system, ... }:
{
  home.packages = [ herdr.packages.${system}.default ];

  # Let Herdr's UI use the ANSI palette provided by the host terminal.
  # Foot receives that palette from `caelestia scheme set`, so Herdr follows
  # the active Caelestia scheme instead of pinning its own RGB theme.
  xdg.configFile."herdr/config.toml".text = ''
    onboarding = false

    [ui]
    show_agent_labels_on_pane_borders = true
    agent_panel_sort = "spaces"

    [theme]
    name = "terminal"
    auto_switch = false
  '';
}
