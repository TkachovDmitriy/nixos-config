{ pkgs, ... }:
{
  home.packages = with pkgs; [
    neovim
    lazygit
    gcc
    gnumake
    unzip
  ];

  home.sessionVariables.EDITOR = "nvim";
}
