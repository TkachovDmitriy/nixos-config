{ ... }:
{
  programs.nushell.shellAliases = {
    ll   = "eza -la --icons --git";
    lt   = "eza --tree --icons --level=2";
    lta  = "eza --tree --icons --level=2 -a";
    la   = "eza -a --icons";
    cat  = "bat";
    catp = "bat -p";
  };

  # dot-navigation needs def --env so cd affects the caller's scope
  programs.nushell.extraConfig = ''
    def --env ".." []   { cd .. }
    def --env "..." []  { cd ../.. }
    def --env "...." [] { cd ../../.. }
  '';
}
