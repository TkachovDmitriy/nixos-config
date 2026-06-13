# nix-config

td's personal **NixOS + Home-Manager** configuration, built with Nix flakes.

It declaratively manages a single x86_64 workstation (`hostname: nixos`) — from
the bootloader and GNOME desktop down to per-user shell aliases and CLI tooling.

## Layout

```
.
├── flake.nix              # Inputs + the nixosConfigurations.nixos output
├── nixos/                 # System-level configuration
│   ├── configuration.nix  # Entry point — imports every module below
│   ├── hardware-configuration.nix
│   └── modules/
│       ├── boot.nix           # systemd-boot / EFI
│       ├── network.nix        # hostname + NetworkManager
│       ├── locale.nix         # locale & timezone
│       ├── desktop.nix        # GNOME (GDM), us/ua keyboard, AppImage
│       ├── sound.nix          # audio stack
│       ├── users.nix          # the `td` user, zsh, firefox
│       ├── docker.nix         # Docker daemon
│       ├── virtualisation.nix # libvirtd / KVM / virt-manager
│       └── packages.nix       # system-wide packages
└── home/                  # User-level configuration (home-manager)
    ├── home.nix           # Entry point — imports every program below
    └── programs/
        ├── cli-tools.nix      # eza, bat, fd, ripgrep, btop, jq, delta, fzf
        ├── zoxide.nix         # smarter cd
        ├── carapace.nix       # shell completions
        ├── wezterm.nix        # terminal emulator
        ├── tmux.nix
        ├── zsh/               # zsh: plugins, completion, starship, aliases/
        ├── nushell/           # nushell + aliases/
        ├── claude-code.nix
        ├── zen-browser.nix
        ├── node.nix
        └── zed.nix            # Zed editor
```

### How it fits together

`flake.nix` exposes one system, `nixosConfigurations.nixos`. It pulls in
`nixos/configuration.nix` and wires Home-Manager in as a NixOS module, so a
single `nixos-rebuild switch` builds both the system and the `td` user
environment in one step.

External flake inputs (`zen-browser`, `claude-code-nix`) are handed to
Home-Manager through `extraSpecialArgs` so program modules can use them
directly.

## Inputs

| Input             | Source                                  | Purpose                       |
| ----------------- | --------------------------------------- | ----------------------------- |
| `nixpkgs`         | `NixOS/nixpkgs` (`nixos-unstable`)      | All packages                  |
| `home-manager`    | `nix-community/home-manager`            | User-level configuration      |
| `zen-browser`     | `youwen5/zen-browser-flake`             | Zen browser                   |
| `claude-code-nix` | `sadjow/claude-code-nix`                | Claude Code CLI               |

## Usage

```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos

# Update all flake inputs and rebuild
cd ~/.config/nix-config && nix flake update && sudo nixos-rebuild switch --flake .#nixos

# Test a build without switching (dry run)
sudo nixos-rebuild dry-build --flake ~/.config/nix-config#nixos

# Check the flake for errors without building
nix flake check

# Garbage collect old generations
sudo nix-collect-garbage -d
```

## Extending the config

**Add a user program:**
1. Create `home/programs/<name>.nix`
2. Import it in `home/home.nix`

**Add a system module:**
1. Create `nixos/modules/<name>.nix`
2. Import it in `nixos/configuration.nix`

**Use a package from an external flake:**
Add the flake input to `flake.nix` and pass it via `extraSpecialArgs`.

## Notable choices

- **Channel:** tracks `nixos-unstable`; `allowUnfree = true`.
- **Flakes & nix-command** enabled; `nix-ld` on for running non-Nix binaries.
- **Desktop:** GNOME on Wayland via GDM, with `gnome-terminal` removed in favour
  of WezTerm (also set as the default GNOME terminal). Keyboard layouts
  `us,ua`, toggled with `Alt+Shift`.
- **Shells:** both zsh (default login shell) and nushell are configured, with
  aliases grouped by domain (common, git, docker, nixos).
- **Virtualisation:** Docker plus libvirtd/KVM with virt-manager; the `td` user
  is in the `docker`, `libvirtd`, and `kvm` groups.
- **state version:** `25.11` (both system and home-manager).
```