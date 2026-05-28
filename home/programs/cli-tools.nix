{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
    btop
    jq
    delta
    fzf
    lazydocker
  ];
}
