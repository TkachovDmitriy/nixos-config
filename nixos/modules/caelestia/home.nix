{ pkgs, caelestia-shell, caelestia-dots, caelestiaHyprConfig, ... }:
{
  home-manager.sharedModules = [
    caelestia-shell.homeManagerModules.default
    ({ config, lib, pkgs, ... }: {
      programs.caelestia = {
        enable = true;
        # Upstream Hyprland config starts the shell only in that session.
        systemd.enable = false;
        cli.enable = true;

        settings = {
          general.apps = {
            terminal = [ "foot" ];
            audio = [ "pwvucontrol" ];
            playback = [ "mpv" ];
            explorer = [ "nautilus" ];
          };
          launcher.vimKeybinds = true;
          services.weatherLocation = "Warsaw";
        };
      };

      home.packages = with pkgs; [
        cliphist
        foot
        gammastep
        hyprpicker
        mpv
        nautilus
        pavucontrol
        pwvucontrol
        trash-cli
        wl-clipboard
      ];

      fonts.fontconfig.enable = true;

      # Foot is Caelestia's native terminal choice: minimal Wayland chrome and
      # live OSC palette updates from `caelestia scheme set`.
      xdg.configFile."foot/foot.ini".text = ''
        shell=${pkgs.nushell}/bin/nu
        title=foot
        font=JetBrains Mono Nerd Font:size=12
        letter-spacing=0
        dpi-aware=no
        pad=25x25
        bold-text-in-bright=no
        gamma-correct-blending=no

        [scrollback]
        lines=10000

        [cursor]
        style=beam
        beam-thickness=1.5

        [colors-dark]
        alpha=0.78
        blur=yes

        [key-bindings]
        scrollback-up-page=Page_Up
        scrollback-down-page=Page_Down
        search-start=Control+Shift+f

        [search-bindings]
        cancel=Escape
        find-prev=Shift+F3
        find-next=F3 Control+G
      '';

      # The CLI rewrites themes/caelestia.theme whenever the active scheme
      # changes. Keep that generated theme mutable, but declaratively select it
      # through the official Caelestia btop configuration.
      xdg.configFile."btop/btop.conf".source = "${caelestia-dots}/btop/btop.conf";

      # The shell ships one official fallback wallpaper. Its picker scans this
      # directory by default; additional personal wallpapers can remain beside
      # this managed file.
      home.file."Pictures/Wallpapers/caelestia.webp".source =
        "${caelestia-shell}/assets/wallpaper.webp";

      # Recursive links leave the directory writable for Caelestia's generated
      # colour scheme while retaining upstream as the source of truth.
      xdg.configFile."hypr" = {
        source = caelestiaHyprConfig;
        recursive = true;
      };

      xdg.configFile."caelestia/hypr-vars.lua".text = ''
        return {
          terminal      = "foot",
          browser       = "zen",
          editor        = "zeditor",
          fileExplorer  = "nautilus",
          audioSettings = "pwvucontrol",
          cursorTheme   = "Adwaita",
        }
      '';

      xdg.configFile."caelestia/hypr-user.lua".text = ''
        -- Local Hyprland overrides belong here.
      '';

      # Avoid the Arch-only GeoClue demo agent used by upstream execs.lua.
      # These coordinates keep automatic night-light transitions working.
      xdg.configFile."gammastep/config.ini".text = ''
        [general]
        location-provider=manual

        [manual]
        lat=52.2297
        lon=21.0122
      '';

      # Keep this mutable so wallpaper-based colour generation can update it.
      home.activation.caelestiaInitialScheme =
        lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          scheme_dir="${config.xdg.configHome}/hypr/scheme"
          if [ ! -e "$scheme_dir/current.lua" ]; then
            run mkdir -p "$scheme_dir"
            run cp "${caelestiaHyprConfig}/scheme/default.lua" "$scheme_dir/current.lua"
          fi
        '';
    })
  ];
}
