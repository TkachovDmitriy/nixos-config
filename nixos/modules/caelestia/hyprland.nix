{ pkgs, caelestia-dots, ... }:

let
  # Upstream dots contain two Arch-specific /usr paths. Patch only those;
  # visuals, animations, rules and keybindings stay identical to upstream.
  hyprConfig = pkgs.runCommand "caelestia-hypr-config" { } ''
    cp -R ${caelestia-dots}/hypr "$out"
    chmod -R u+w "$out"

    substituteInPlace "$out/hyprland/execs.lua" \
      --replace-fail "/usr/lib/polkit-gnome/polkit-gnome-authentication-agent-1" \
        "${pkgs.polkit_gnome}/libexec/polkit-gnome-authentication-agent-1" \
      --replace-fail "/usr/lib/geoclue-2.0/demos/agent" \
        "true"

    substituteInPlace "$out/hyprland/input.lua" \
      --replace-fail 'kb_layout          = "us",' \
        'kb_layout          = "us,ua",
        kb_options         = "grp:alt_shift_toggle",'
  '';
in
{
  # Expose the patched upstream config to the sibling Home Manager module.
  _module.args.caelestiaHyprConfig = hyprConfig;
}
