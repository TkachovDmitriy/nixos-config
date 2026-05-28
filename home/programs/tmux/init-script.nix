{ }:
''
  SESSION=$1

  # Window 1: main — split left/right
  tmux rename-window -t "$SESSION:1" "main"
  tmux split-window -h -t "$SESSION:1"
  tmux select-pane -t "$SESSION:1.1"

  # Window 2: work — split left/right
  tmux new-window -t "$SESSION" -n "work"
  tmux split-window -h -t "$SESSION:2"
  tmux select-pane -t "$SESSION:2.1"

  # Window 3: editor — open nvim
  tmux new-window -t "$SESSION" -n "editor"
  tmux send-keys -t "$SESSION:3" "nvim" Enter

  # Land on window 1
  tmux select-window -t "$SESSION:1"
''
