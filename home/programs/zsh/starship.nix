{ ... }:
{
  programs.starship = {
    enable               = true;
    enableZshIntegration = true;
    settings = {
      add_newline = true;

      format = ''
        $directory$git_branch$git_status$nodejs$rust$docker_context
        $character
      '';

      character = {
        success_symbol = "[❯](bold green)";
        error_symbol   = "[❯](bold red)";
      };

      directory = {
        truncation_length = 3;
        truncate_to_repo  = true;
        style             = "bold cyan";
      };

      git_branch = {
        symbol = " ";
        style  = "bold purple";
      };

      git_status = {
        conflicted = "⚡";
        ahead      = "⇡\${count}";
        behind     = "⇣\${count}";
        diverged   = "⇕⇡\${ahead_count}⇣\${behind_count}";
        modified   = "!";
        untracked  = "?";
        staged     = "+";
        deleted    = "✘";
      };

      nodejs = {
        symbol = " ";
        style  = "bold green";
      };

      rust = {
        symbol = " ";
        style  = "bold orange";
      };

      docker_context = {
        symbol = " ";
        style  = "bold blue";
      };
    };
  };
}
