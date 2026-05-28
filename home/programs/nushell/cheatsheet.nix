{ ... }:
{
  home.file.".config/cheatsheets/tmux.md".text = ''
    # Tmux  (prefix: C-a)

    ## Sessions
    C-a T        sesh session picker (fzf)
    C-a S        choose session
    C-a $        rename session
    C-a d / ^D   detach
    C-a *        list clients

    ## Windows
    C-a t / ^C   new window (home dir)
    C-a H        previous window
    C-a L        next window
    C-a ^A       last window
    C-a w / ^W   list windows
    C-a r        rename window
    C-a "        choose window

    ## Panes
    C-a s / ^S   split horizontal (same path)
    C-a v / ^V   split vertical (same path)
    C-a h/j/k/l  navigate panes
    C-a z / ^Z   zoom / unzoom pane
    C-a c        kill pane
    C-a x        swap pane down
    C-a ,  .     resize left / right
    C-a -  =     resize down / up
    C-a P        toggle pane border labels
    C-a K        clear pane
    C-a p        floax floating terminal

    ## Copy mode (vi)
    C-a [        enter copy mode
    v            begin selection
    y            yank to clipboard
    q / Esc      exit copy mode

    ## Plugins
    C-a U        open URL (fzf-tmux-url)
    C-a F        tmux-fzf menu
    C-a Space    tmux-thumbs (copy hints)
    C-a ^R       refresh client
    C-a :        command prompt
  '';

  home.file.".config/cheatsheets/git.md".text = ''
    # Git Aliases

    ## Status & Staging
    s  / gs      git status -sb / git status
    ga           git add
    gaa          git add --all
    gapa         git add --patch

    ## Commit
    gcmsg        git commit -m
    gcam         git commit -a -m
    gc           git commit -v
    gc!          git commit --amend

    ## Branch & Checkout
    gco          git checkout
    gcb          git checkout -b
    gcm          git checkout master
    gb / gba     git branch / --all
    gbd          git branch -d

    ## Fetch / Pull / Push
    gf / gfa     git fetch / --all --prune
    gl / gup     git pull / --rebase
    gp           git push
    ggpull       git pull origin <branch>
    ggp          git push origin <branch>
    ggpf         git push --force-with-lease
    gpsup        git push --set-upstream origin <branch>

    ## Rebase
    grbi         git rebase -i
    grbc / grba  rebase continue / abort

    ## Stash
    gsta / gstp  stash save / pop
    gstl / gstd  stash list / drop

    ## Log & Diff
    glo          git log --oneline --decorate
    glog         git log --oneline --graph
    gloga        git log --oneline --graph --all
    gd / gdca    git diff / --cached
    glg          git log --stat

    ## Misc
    grt          cd to git root
    gbl          git blame
    gclean       git clean -fd
    gcl          git clone --recursive
    gcf          git config --list
  '';

  home.file.".config/cheatsheets/docker.md".text = ''
    # Docker Aliases

    ## Containers
    d            docker
    dps / dpsa   docker ps / -a
    dex          docker exec -it
    dlog         docker logs -f
    dprune       docker system prune -af
    dvp          docker volume prune
    ld           lazydocker (TUI)

    ## Images
    di           docker images

    ## Compose
    dc           docker compose
    dcu          docker compose up
    dcud         docker compose up -d
    dcd          docker compose down
    dcl          docker compose logs -f
  '';

  home.file.".config/cheatsheets/cli.md".text = ''
    # CLI Tools

    ## Navigation
    z <query>    zoxide jump to dir
    ya           yazi file manager (cd on exit)
    ..  ...      cd .. / cd ../..

    ## Files
    ls / ll      eza icons / long + git info
    lt / lta     eza tree level 2 / with hidden
    cat          bat (syntax highlight)
    catp         bat plain (no decorations)

    ## Search & Find
    rg           ripgrep (fast grep)
    fd           find replacement
    fzf          fuzzy finder (Ctrl+T files, Ctrl+R history)

    ## History
    Ctrl+R       atuin history search
    atuin        full history TUI

    ## System
    btop         interactive system monitor

    ## Data
    jq           JSON processor

    ## Dev
    ld           lazydocker TUI

    ## NixOS
    rebuild      nixos-rebuild switch --flake
    update       nix flake update + rebuild
    cleanup      nix garbage collect
    nixedit      cd ~/.config/nix-config
  '';

  programs.nushell.extraConfig = ''
    def keys [topic?: string] {
      let dir = ($env.HOME | path join ".config/cheatsheets")
      if ($topic == null) {
        let choice = (
          ls $dir | get name
          | each { |f| $f | path basename | str replace ".md" "" }
          | str join "\n"
          | fzf --prompt=" cheatsheet > "
        )
        if ($choice | is-not-empty) {
          bat --style=plain --color=always ($dir | path join $"($choice).md")
        }
      } else {
        let file = ($dir | path join $"($topic).md")
        if ($file | path exists) {
          bat --style=plain --color=always $file
        } else {
          print $"No cheatsheet for: ($topic)"
        }
      }
    }
  '';
}
