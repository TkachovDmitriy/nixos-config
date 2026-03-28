{ ... }:
{
  programs.zsh.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos";
    update  = "cd ~/.config/nix-config && nix flake update && sudo nixos-rebuild switch --flake .#nixos";
    cleanup = "sudo nix-collect-garbage -d";
    nixedit = "cd ~/.config/nix-config";
  };
}
