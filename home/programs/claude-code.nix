{ claude-code-nix, system, ... }:
{
  home.packages = [
    claude-code-nix.packages.${system}.claude-code
  ];
}
