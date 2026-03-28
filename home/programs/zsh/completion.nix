{ pkgs, ... }:
{
  programs.fzf = {
    enable               = true;
    enableZshIntegration = true;
  };

  programs.zsh = {
    plugins = [
      {
        name = "zsh-history-substring-search";
        src  = pkgs.zsh-history-substring-search;
      }
    ];

    initContent = ''
      # Має бути ПІСЛЯ завантаження плагіну
      bindkey '^[[A' history-substring-search-up
      bindkey '^[[B' history-substring-search-down

      # Ctrl+стрілки — переміщення по словах
      bindkey '^[[1;5C' forward-word
      bindkey '^[[1;5D' backward-word

      # Меню автокомпліту зі стрілками
      zstyle ':completion:*' menu select
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Z}'
      zstyle ':completion:*' list-colors ""
      zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

      # Helper для push/pull поточної гілки
      function git_current_branch() {
        git branch --show-current 2>/dev/null
      }
    '';
  };
}
