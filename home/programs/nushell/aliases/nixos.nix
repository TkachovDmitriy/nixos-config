{ ... }:
{
  programs.nushell.shellAliases = {
    rebuild = "sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos";
    cleanup = "sudo nix-collect-garbage -d";
  };

  # cd-based commands need --env flag
  programs.nushell.extraConfig = ''
    def --env nixedit [] { cd ~/.config/nix-config }

    def --env update [] {
      cd ~/.config/nix-config
      nix flake update
      sudo nixos-rebuild switch --flake ".#nixos"
    }
  '';
}
