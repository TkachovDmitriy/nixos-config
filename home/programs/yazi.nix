{ ... }:
{
  programs.yazi = {
    enable = true;
    shellWrapperName = "y";
    settings = {
      manager = {
        show_hidden   = false;
        sort_by       = "natural";
        sort_dir_first = true;
      };
    };
  };

  # Shell wrapper: cd into last directory on exit
  programs.zsh.initContent = ''
    function ya() {
      local tmp cwd
      tmp="$(mktemp -t yazi-cwd.XXXXXX)"
      yazi "$@" --cwd-file="$tmp"
      if cwd="$(cat -- "$tmp")" && [[ -n "$cwd" && "$cwd" != "$PWD" ]]; then
        cd -- "$cwd"
      fi
      rm -f -- "$tmp"
    }
  '';
}
