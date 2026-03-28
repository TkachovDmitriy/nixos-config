{ ... }:
{
  programs.zsh.shellAliases = {
    ls     = "eza --icons";
    ll     = "eza -la --icons --git";
    lt     = "eza --tree --icons --level=2";
    lta    = "eza --tree --icons --level=2 -a";
    la     = "eza -a --icons";
    cat    = "bat";
    catp   = "bat -p";
    ".."   = "cd ..";
    "..."  = "cd ../..";
    "...." = "cd ../../..";
  };
}
