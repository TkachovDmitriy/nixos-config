{ ... }:
{
  programs.atuin = {
    enable                = true;
    enableZshIntegration  = true;
    settings = {
      auto_sync    = false;
      update_check = false;
      style        = "compact";
      # don't pollute history with quick navigation commands
      history_filter = [
        "^ls"
        "^ll"
        "^la"
        "^lt"
        "^cd$"
        "^z "
        "^\\.\\."
      ];
    };
  };
}
