{ ... }:
{
  programs.nushell.shellAliases = {
    lg     = "lazygit";
    g      = "git";
    s      = "git status -sb";
    gs     = "git status";
    gst    = "git status";
    gsb    = "git status -sb";
    gss    = "git status -s";
    ga     = "git add";
    gaa    = "git add --all";
    gapa   = "git add --patch";
    gau    = "git add --update";
    gc     = "git commit -v";
    gca    = "git commit -v -a";
    gcam   = "git commit -a -m";
    gcmsg  = "git commit -m";
    gcs    = "git commit -S";
    gcsm   = "git commit -s -m";
    gco    = "git checkout";
    gcb    = "git checkout -b";
    gcm    = "git checkout master";
    gcd    = "git checkout develop";
    gb     = "git branch";
    gba    = "git branch -a";
    gbd    = "git branch -d";
    gbnm   = "git branch --no-merged";
    gbr    = "git branch --remote";
    gf     = "git fetch";
    gfa    = "git fetch --all --prune";
    gfo    = "git fetch origin";
    gl     = "git pull";
    gpl    = "git pull";
    gup    = "git pull --rebase";
    gupv   = "git pull --rebase -v";
    glum   = "git pull upstream master";
    gp     = "git push";
    gpd    = "git push --dry-run";
    gpv    = "git push -v";
    gpu    = "git push upstream";
    grb    = "git rebase";
    grba   = "git rebase --abort";
    grbc   = "git rebase --continue";
    grbi   = "git rebase -i";
    grbm   = "git rebase master";
    grbs   = "git rebase --skip";
    grh    = "git reset HEAD";
    grhh   = "git reset HEAD --hard";
    gru    = "git reset --";
    gsta   = "git stash save";
    gstaa  = "git stash apply";
    gstc   = "git stash clear";
    gstd   = "git stash drop";
    gstl   = "git stash list";
    gstp   = "git stash pop";
    gsts   = "git stash show --text";
    glo    = "git log --oneline --decorate";
    glog   = "git log --oneline --decorate --graph";
    gloga  = "git log --oneline --decorate --graph --all";
    glg    = "git log --stat";
    glgga  = "git log --graph --decorate --all";
    glgm   = "git log --graph --max-count=10";
    gd     = "git diff";
    gdca   = "git diff --cached";
    gdw    = "git diff --word-diff";
    gm     = "git merge";
    gmom   = "git merge origin/master";
    gmum   = "git merge upstream/master";
    gr     = "git remote";
    gra    = "git remote add";
    grv    = "git remote -v";
    grup   = "git remote update";
    grmv   = "git remote rename";
    grrm   = "git remote remove";
    grset  = "git remote set-url";
    gcp    = "git cherry-pick";
    gcpa   = "git cherry-pick --abort";
    gcpc   = "git cherry-pick --continue";
    gcl    = "git clone --recursive";
    gcf    = "git config --list";
    gcount = "git shortlog -sn";
    gbl    = "git blame -b -w";
    gignore   = "git update-index --assume-unchanged";
    gunignore = "git update-index --no-assume-unchanged";
    gclean    = "git clean -fd";
  };

  # Aliases that need the current branch name
  programs.nushell.extraConfig = ''
    def git-current-branch [] {
      git branch --show-current | str trim
    }

    def ggpull [] { git pull origin (git-current-branch) }
    def ggpush [] { git push origin (git-current-branch) }
    def ggp    [] { git push origin (git-current-branch) }
    def ggpf   [] { git push --force-with-lease origin (git-current-branch) }
    def gpsup  [] { git push --set-upstream origin (git-current-branch) }

    # cd to git repo root
    def --env grt [] {
      let root = (git rev-parse --show-toplevel | str trim)
      if $root == "" { cd . } else { cd $root }
    }
  '';
}
