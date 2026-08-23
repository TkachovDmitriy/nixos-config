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
    sidebar_bg = "__HERDR_SURFACE__"
    surface0 = "__HERDR_SURFACE_CONTAINER__"
    surface1 = "__HERDR_SURFACE_HIGH__"
    surface_dim = "__HERDR_SURFACE_DIM__"
    text = "__HERDR_TEXT__"
    subtext0 = "__HERDR_SUBTEXT__"
    overlay0 = "__HERDR_OUTLINE__"
    red = "__HERDR_ERROR__"
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
      surface=""
      surface_container=""
      surface_high=""
      surface_dim=""
      text=""
      subtext=""
      outline=""
      error=""

      scheme_color() {
        sed -n "s/^[[:space:]]*$1[[:space:]]*=[[:space:]]*\"\([0-9A-Fa-f]\{6\}\)\".*/\1/p" "$scheme_file" | head -n 1
      }

      if [ -f "$scheme_file" ]; then
        accent="$(sed -n 's/^[[:space:]]*primary[[:space:]]*=[[:space:]]*"\([0-9A-Fa-f]\{6\}\)".*/\1/p' "$scheme_file" | head -n 1)"
        surface="$(scheme_color surface)"
        surface_container="$(scheme_color surfaceContainer)"
        surface_high="$(scheme_color surfaceContainerHigh)"
        surface_dim="$(scheme_color surfaceDim)"
        text="$(scheme_color onSurface)"
        subtext="$(scheme_color onSurfaceVariant)"
        outline="$(scheme_color outline)"
        error="$(scheme_color error)"
      fi

      # Keep Herdr valid during first login, before Caelestia has generated a scheme.
      if ! printf '%s' "$accent" | grep -Eq '^[0-9A-Fa-f]{6}$'; then
        accent="89b4fa"
      fi

      for value_name in surface surface_container surface_high surface_dim text subtext outline error; do
        value="$(eval "printf '%s' \"\$$value_name\"")"
        if ! printf '%s' "$value" | grep -Eq '^[0-9A-Fa-f]{6}$'; then
          case "$value_name" in
            surface) value="020305" ;;
            surface_container) value="05070a" ;;
            surface_high) value="07090d" ;;
            surface_dim) value="020305" ;;
            text) value="e3e5ef" ;;
            subtext) value="a8abb5" ;;
            outline) value="72757e" ;;
            error) value="fa746f" ;;
          esac
          eval "$value_name=\$value"
        fi
      done

      install -d "$(dirname "$config_file")"
      sed \
        -e "s|__HERDR_PRIMARY__|#$accent|" \
        -e "s|__HERDR_SURFACE__|#$surface|" \
        -e "s|__HERDR_SURFACE_CONTAINER__|#$surface_container|" \
        -e "s|__HERDR_SURFACE_HIGH__|#$surface_high|" \
        -e "s|__HERDR_SURFACE_DIM__|#$surface_dim|" \
        -e "s|__HERDR_TEXT__|#$text|" \
        -e "s|__HERDR_SUBTEXT__|#$subtext|" \
        -e "s|__HERDR_OUTLINE__|#$outline|" \
        -e "s|__HERDR_ERROR__|#$error|" \
        "${herdrConfigTemplate}" > "$config_file"

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
