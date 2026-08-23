{
  config,
  herdr,
  lib,
  pkgs,
  system,
  ...
}:
let
  herdrPackage = herdr.packages.${system}.default;

  herdrConfigTemplate = pkgs.writeText "herdr-config.toml" ''
    onboarding = false

    [ui]
    accent = "__HERDR_PRIMARY__"
    show_agent_labels_on_pane_borders = true
    agent_panel_sort = "spaces"

    [theme]
    name = "terminal"
    auto_switch = false

    [theme.custom]
    panel_bg = "reset"
  '';

  herdrThemeSync = pkgs.writeShellApplication {
    name = "herdr-theme-sync";
    runtimeInputs = with pkgs; [
      coreutils
      gnused
    ];
    text = ''
      set -euo pipefail

      scheme_file="${config.xdg.configHome}/hypr/scheme/current.lua"
      config_file="${config.xdg.configHome}/herdr/config.toml"
      accent=""

      if [ -f "$scheme_file" ]; then
        accent="$(sed -n 's/^[[:space:]]*primary[[:space:]]*=[[:space:]]*"\([0-9A-Fa-f]\{6\}\)".*/\1/p' "$scheme_file" | head -n 1)"
      fi

      # Keep Herdr valid during first login, before Caelestia has generated a scheme.
      if ! printf '%s' "$accent" | grep -Eq '^[0-9A-Fa-f]{6}$'; then
        accent="89b4fa"
      fi

      install -d "$(dirname "$config_file")"
      sed "s|__HERDR_PRIMARY__|#$accent|" "${herdrConfigTemplate}" > "$config_file"

      ${lib.getExe herdrPackage} server reload-config >/dev/null 2>&1 || true
    '';
  };
in
{
  home.packages = [
    herdrPackage
    herdrThemeSync
  ];

  # Herdr reads this mutable, theme-synchronized file instead of the
  # Home-Manager-managed template directly.
  home.sessionVariables.HERDR_CONFIG_PATH = "${config.xdg.configHome}/herdr/config.toml";

  home.activation.herdrThemeSync = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    run ${lib.getExe herdrThemeSync}
  '';

  systemd.user.paths.herdrThemeSync = {
    Unit = {
      Description = "Watch the Caelestia scheme for Herdr accent changes";
    };
    Path = {
      PathChanged = "${config.xdg.configHome}/hypr/scheme/current.lua";
      Unit = "herdrThemeSync.service";
    };
    Install.WantedBy = [ "default.target" ];
  };

  systemd.user.services.herdrThemeSync = {
    Unit = {
      Description = "Synchronize Herdr accent with the Caelestia primary color";
    };
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe herdrThemeSync;
    };
  };

}
