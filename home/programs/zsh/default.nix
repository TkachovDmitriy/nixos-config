{ pkgs, ... }:
{
  imports = [
    ./plugins.nix
    ./completion.nix
    ./starship.nix
    ./aliases/common.nix
    ./aliases/git.nix
    ./aliases/docker.nix
    ./aliases/nixos.nix
  ];

  programs.zsh = {
    enable = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;
    enableCompletion = true;

    history = {
      size = 50000;
      save = 50000;
      ignoreDups = true;
      ignoreSpace = true;
      share = true;
      extended = true;
    };

  };
}
