{ pkgs, ... }:
{
  imports = [
    ./aliases/common.nix
    ./aliases/git.nix
    ./aliases/docker.nix
    ./aliases/nixos.nix
  ];

  programs.nushell = {
    enable = true;

    plugins = with pkgs.nushellPlugins; [
      gstat    # structured git status (use `gstat` in pipelines)
      formats  # extra file format support (parquet, ods, etc.)
      query    # query structured data / web pages
    ];

    extraConfig = ''
      $env.config.show_banner = false
      $env.LIBVIRT_DEFAULT_URI = "qemu:///system"

      $env.config.history = {
        max_size: 50000
        sync_on_enter: true
        file_format: "sqlite"
        isolation: false
      }

      $env.config.completions = {
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
      }

      # Keep emacs-style keybindings (Ctrl+A/E/W etc.)
      $env.config.edit_mode = "emacs"

      # A compact rice-style system summary for each new interactive session.
      if $nu.is-interactive {
        fastfetch
      }
    '';
  };
}
