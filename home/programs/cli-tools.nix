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
    lazygit
    lazydocker
    alsa-utils   # alsamixer
    awscli2      # aws
  ];
}
