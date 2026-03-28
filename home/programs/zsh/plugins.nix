{ pkgs, ... }:
{
  programs.zsh.plugins = [
    {
      name = "zsh-completions";
      src  = pkgs.zsh-completions;
    }
    {
      name = "zsh-autopair";
      src  = pkgs.zsh-autopair;
    }
  ];
}
