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

    def nix-clean [
      --gc        # garbage collect all generations
      --b         # delete old generations
      keep?: int  # number of generations to keep (default 3)
    ] {
      if $gc {
        sudo nix-collect-garbage -d
      } else if $b {
        let k = ($keep | default 3)
        sudo nix-env -p /nix/var/nix/profiles/system --delete-generations $"+($k)"
      } else {
        print "Usage: nix-clean --gc | nix-clean --b [keep]"
      }
    }
  '';
}
