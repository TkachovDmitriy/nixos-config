{ ... }:
{
  programs.nushell.shellAliases = {
    rebuild      = "sudo nixos-rebuild switch --flake ~/.config/nix-config#nixos";
    rebuild-boot = "sudo nixos-rebuild boot --flake ~/.config/nix-config#nixos";
    cleanup      = "sudo nix-collect-garbage -d";
  };

  # cd-based commands need --env flag
  programs.nushell.extraConfig = ''
    def nix-cleanup [keep: int = 4] {
      sudo nix-env -p /nix/var/nix/profiles/system --delete-generations $"+($keep)"
      sudo nix-collect-garbage
    }

    def --env nixedit [] { cd ~/.config/nix-config }

    def --env update [] {
      cd ~/.config/nix-config
      nix flake update
      sudo nixos-rebuild switch --flake ".#nixos"
    }
  '';
}
