# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Common Commands

```bash
# Apply configuration changes
sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos

# Update all flake inputs and rebuild
cd ~/.config/nix-config && nix flake update && sudo nixos-rebuild switch --flake .#nixos

# Test a build without switching (dry run)
sudo nixos-rebuild dry-build --flake ~/.config/nix-config#nixos

# Check flake for errors without building
nix flake check

# Garbage collect old generations
sudo nix-collect-garbage -d
```

## Architecture

This is a **NixOS + Home-Manager** configuration using Nix flakes. The repository splits into two layers:

- **`nixos/`** — System-level configuration (boot, networking, desktop, users, packages). Entry point is `nixos/configuration.nix`, which imports all modules under `nixos/modules/`.
- **`home/`** — User-level configuration managed by home-manager. Entry point is `home/home.nix`, which imports program modules under `home/programs/`.

### Flake Structure

`flake.nix` wires everything together:
- Uses `nixpkgs-unstable` for all packages
- Passes flake inputs (`zen-browser-flake`, `claude-code-nix`) to home-manager via `extraSpecialArgs`
- Exports a single system config: `nixosConfigurations.nixos` (x86\_64-linux)

### Home-Manager Programs

Each program in `home/programs/` is a self-contained module. The `zsh/` subdirectory is further split:
- `default.nix` — core zsh config, imports the rest
- `plugins.nix`, `completion.nix`, `starship.nix` — specific zsh features
- `aliases/` — grouped by domain: `common.nix`, `git.nix`, `docker.nix`, `nixos.nix`

### Adding New Programs

To add a new user program:
1. Create `home/programs/<name>.nix`
2. Import it in `home/home.nix`

To add a new system module:
1. Create `nixos/modules/<name>.nix`
2. Import it in `nixos/configuration.nix`

To use a package from an external flake, add the flake input to `flake.nix` and pass it via `extraSpecialArgs`.
