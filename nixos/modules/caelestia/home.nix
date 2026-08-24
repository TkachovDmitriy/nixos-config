{
  pkgs,
  caelestia-shell,
  caelestia-dots,
  caelestiaHyprConfig,
  ...
}:
{
  home-manager.sharedModules = [
    caelestia-shell.homeManagerModules.default
    (
      {
        config,
        lib,
        pkgs,
        ...
      }:
      let
        wallr = pkgs.callPackage ../../../pkgs/wallr.nix { };
        celestialWall = pkgs.writeShellApplication {
          name = "celestial-wall";
          runtimeInputs = with pkgs; [
            coreutils
            findutils
            systemd
          ];
          text = ''
            wallpaper_dir="$HOME/Pictures/Wallpapers/wide"
            state_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/celestial-wall"
            current_file="$state_dir/current"
            default_wallpaper="$wallpaper_dir/whisper-of-the-shadow-elf-WIDE-live.mp4"

            usage() {
              cat <<'EOF'
            Usage: celestial-wall <command> [argument]

              start [video]   Start live wallpaper (last selected by default)
              set <video>     Select and start a video on DP-1
              stop            Stop live wallpaper and restore awww
              toggle          Toggle live/static wallpaper
              next            Select the next *-WIDE-live.mp4
              pause           Pause video playback
              resume          Resume video playback
              status          Show service, GPU and decoder status
              awake [time]    Keep displays awake temporarily (default: 1h)
              sleep           Cancel the temporary keep-awake inhibitor
            EOF
            }

            resolve_video() {
              local requested="''${1:-}"
              if [ -z "$requested" ] && [ -s "$current_file" ]; then
                requested="$(<"$current_file")"
              fi
              if [ -z "$requested" ]; then
                requested="$default_wallpaper"
              elif [ ! -f "$requested" ] && [ -f "$wallpaper_dir/$requested" ]; then
                requested="$wallpaper_dir/$requested"
              fi
              if [ ! -f "$requested" ]; then
                echo "Video does not exist: $requested" >&2
                exit 1
              fi
              readlink -f -- "$requested"
            }

            start_daemon() {
              # Keep awww alive for the laptop output while Wallr owns DP-1.
              systemctl --user start awww.service
              systemctl --user start wallr.service
              for _ in $(seq 1 40); do
                if wallr ipc status >/dev/null 2>&1; then
                  return
                fi
                sleep 0.1
              done
              echo "Wallr did not become ready" >&2
              systemctl --user status wallr.service --no-pager >&2 || true
              exit 1
            }

            set_video() {
              local video
              video="$(resolve_video "''${1:-}")"
              start_daemon
              wallr set "$video" --mode fit --monitor DP-1 --no-theme
              mkdir -p "$state_dir"
              printf '%s\n' "$video" > "$current_file"
              echo "Live wallpaper: $video"
            }

            case "''${1:-}" in
              start)
                set_video "''${2:-}"
                ;;
              set)
                [ -n "''${2:-}" ] || { usage >&2; exit 2; }
                set_video "$2"
                ;;
              stop)
                wallr quit >/dev/null 2>&1 || true
                systemctl --user stop wallr.service
                systemctl --user start awww.service
                echo "Live wallpaper stopped; awww restored"
                ;;
              toggle)
                if systemctl --user is-active --quiet wallr.service; then
                  "$0" stop
                else
                  "$0" start
                fi
                ;;
              next)
                mapfile -d $'\0' videos < <(find "$wallpaper_dir" -maxdepth 1 -type f \
                  -name '*-WIDE-live.mp4' -print0 | sort -z)
                [ "''${#videos[@]}" -gt 0 ] || {
                  echo "No wide live wallpapers in $wallpaper_dir" >&2
                  exit 1
                }
                current=""
                [ -s "$current_file" ] && current="$(<"$current_file")"
                next="''${videos[0]}"
                for index in "''${!videos[@]}"; do
                  if [ "''${videos[$index]}" = "$current" ]; then
                    next="''${videos[$(( (index + 1) % ''${#videos[@]} ))]}"
                    break
                  fi
                done
                set_video "$next"
                ;;
              pause)
                wallr ipc pause
                ;;
              resume)
                wallr ipc resume
                ;;
              status)
                systemctl --user status wallr.service --no-pager || true
                if systemctl --user is-active --quiet wallr.service; then
                  wallr ipc info --monitor DP-1
                fi
                ;;
              awake)
                duration="''${2:-1h}"
                systemctl --user stop celestial-wall-awake.service >/dev/null 2>&1 || true
                systemd-run --user --unit=celestial-wall-awake --collect \
                  systemd-inhibit --what=idle:sleep --mode=block \
                    --who=celestial-wall --why="Live wallpaper preview" \
                    sleep "$duration"
                echo "Display idle inhibited for $duration"
                ;;
              sleep)
                systemctl --user stop celestial-wall-awake.service
                echo "Display idle inhibitor stopped"
                ;;
              *)
                usage
                [ -n "''${1:-}" ] && exit 2 || exit 0
                ;;
            esac
          '';
        };
      in
      {
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
            # awww (the renamed successor to swww) renders the desktop wallpaper;
            # Caelestia still controls the
            # shell, picker and wallpaper-derived colour scheme.
            background.wallpaperEnabled = false;
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
          awww
          wallr
          wl-clipboard
          celestialWall
          (writeShellApplication {
            name = "caelestia-hotkeys";
            runtimeInputs = [ less ];
            text = ''
              exec foot --title="Hotkey cheat sheet" \
                less --RAW-CONTROL-CHARS \
                "$HOME/.config/caelestia/hotkeys.txt"
            '';
          })
          (writeShellApplication {
            name = "wallpaper-set";
            runtimeInputs = [ coreutils ];
            text = ''
              if [ "$#" -lt 2 ] || [ "$#" -gt 4 ]; then
                echo "Usage: wallpaper-set <DP-1|eDP-1> <image> [--crop|--fit] [--scheme]" >&2
                exit 2
              fi

              output="$1"
              wallpaper="$2"
              resize="crop"
              scheme=false
              shift 2

              for option in "$@"; do
                case "$option" in
                  --crop) resize="crop" ;;
                  --fit) resize="fit" ;;
                  --scheme) scheme=true ;;
                  *)
                    echo "Unknown option: $option" >&2
                    exit 2
                    ;;
                esac
              done

              case "$output" in
                DP-1|eDP-1) ;;
                *)
                  echo "Unknown output: $output (expected DP-1 or eDP-1)" >&2
                  exit 2
                  ;;
              esac

              if [ ! -f "$wallpaper" ]; then
                echo "Wallpaper does not exist: $wallpaper" >&2
                exit 1
              fi
              wallpaper="$(readlink -f -- "$wallpaper")"

              ${pkgs.awww}/bin/awww img \
                --outputs "$output" \
                --resize "$resize" \
                --transition-type fade \
                "$wallpaper"

              if [ "$scheme" = true ]; then
                caelestia wallpaper -f "$wallpaper"
              fi
            '';
          })
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
        xdg.configFile."btop/btop.conf" = {
          source = "${caelestia-dots}/btop/btop.conf";
          force = true;
        };

        # The shell ships one official fallback wallpaper. Its picker scans this
        # directory by default; additional personal wallpapers can remain beside
        # this managed file.
        home.file."Pictures/Wallpapers/caelestia.webp".source = "${caelestia-shell}/assets/wallpaper.webp";

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

        xdg.configFile."caelestia/hotkeys.txt".text = ''
          CAELESTIA / HYPRLAND HOTKEYS
          Open: Super + F1                         Close this sheet: q or Esc

          APPLICATIONS
          Super + T          terminal              Super + W          browser
          Super + E          file manager          Super + C          editor
          Super              application launcher Super + V          clipboard
          Super + .          emoji picker          Ctrl + Alt + V     audio settings

          WINDOWS
          Super + Q          close                 Super + F          fullscreen
          Super + Alt + Space  toggle floating     Alt + Tab          next window
          Super + Z + mouse  move                  Super + X + mouse  resize

          WORKSPACES
          Super + 1…0        switch workspace      Super + wheel      adjacent workspace
          Super + Alt + 1…0  move window           Super + S          special workspace

          CAELESTIA
          Super + N          sidebar               Super + K          show panels
          Super + L          lock                  Ctrl + Alt + Del   session menu
          Ctrl + Shift + Esc system monitor

          SCREENSHOTS
          Print              screenshot            Super + Shift + S  frozen screenshot
          Super + Shift + Alt + S  select a region

          Tip: Super is the key bearing the Windows logo.
        '';

        xdg.configFile."caelestia/hypr-user.lua".text = ''
          -- Match the virtual layout to the physical desk: the ultrawide is on
          -- the left and the laptop panel is on the right.
          hl.monitor({
            output   = "DP-1",
            mode     = "3440x1440@60",
            position = "0x0",
            scale    = 1,
          })

          hl.monitor({
            output   = "eDP-1",
            mode     = "3456x2160@60",
            position = "3440x0",
            scale    = 1,
          })

          -- Keep an easy-to-reach cheat sheet available while learning the setup.
          hl.bind("SUPER + F1", hl.dsp.exec_cmd("caelestia-hotkeys"))

          -- The user service owns the wallpaper daemon outside Caelestia.
          hl.on("hyprland.start", function()
            hl.exec_cmd("systemctl --user start awww.service")
          end)
        '';

        systemd.user.services.awww = {
          Unit = {
            Description = "awww Wayland wallpaper daemon";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Install.WantedBy = [ "graphical-session.target" ];
          Service = {
            ExecStart = "${pkgs.awww}/bin/awww-daemon";
            Restart = "on-failure";
          };
        };

        # Installed and ready, but deliberately not enabled at login. Use
        # `celestial-wall start`, `stop` or `toggle` to control it manually.
        systemd.user.services.wallr = {
          Unit = {
            Description = "Wallr live wallpaper daemon";
            PartOf = [ "graphical-session.target" ];
            After = [ "graphical-session.target" ];
          };
          Service = {
            ExecStart = "${wallr}/bin/wallr daemon --max-fps 30";
            Environment = [
              "LIBVA_DRIVER_NAME=iHD"
              "WGPU_POWER_PREF=low"
            ];
            Restart = "on-failure";
            RestartSec = 1;
          };
        };

        xdg.configFile."wallr/config.yaml".text = ''
          wallpaper:
            loop_video: true
            mute: true
          video:
            hw_decode: "vaapi"
            preferred_gpu: "integrated"
            preload_frames: 2
          theme:
            provider: "none"
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
        home.activation.caelestiaInitialScheme = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
          scheme_dir="${config.xdg.configHome}/hypr/scheme"
          if [ ! -e "$scheme_dir/current.lua" ]; then
            run mkdir -p "$scheme_dir"
            run cp "${caelestiaHyprConfig}/scheme/default.lua" "$scheme_dir/current.lua"
          fi
        '';
      }
    )
  ];
}
