{ tmuxInit }:
''
  # ── Auto-layout on every new session ─────────────────────────────────
  set-hook -g after-new-session 'run-shell "${tmuxInit} #{session_name}"'

  # ── sesh session picker (prefix + T) ──────────────────────────────────
  bind-key T run-shell "sesh connect $(
    sesh list --icons | fzf-tmux -p 55%,60% \
      --no-sort --ansi --border-label ' sesh ' \
      --prompt '⚡  ' \
      --header '  ^a all ^t tmux ^g configs ^x zoxide ^d tmux kill ^f find' \
      --bind 'tab:down,btab:up' \
      --bind 'ctrl-a:change-prompt(⚡  )+reload(sesh list --icons)' \
      --bind 'ctrl-t:change-prompt(🪟  )+reload(sesh list -t --icons)' \
      --bind 'ctrl-g:change-prompt(⚙️  )+reload(sesh list -c --icons)' \
      --bind 'ctrl-x:change-prompt(📁  )+reload(sesh list -z --icons)' \
      --bind 'ctrl-f:change-prompt(🔎  )+reload(fd -H -d 2 -t d -E .Trash . ~)' \
      --bind 'ctrl-d:execute(tmux kill-session -t {})+change-prompt(⚡  )+reload(sesh list --icons)' \
  )"
''
