{ pkgs, ... }:
{
  home.packages = with pkgs; [
    eza
    bat
    fd
    ripgrep
    btop
    jq
    delta
    fzf
    lazygit
    lazydocker
    cava
    cbonsai
    onefetch
    pipes-rs
    tty-clock
    unimatrix
    alsa-utils # alsamixer
    awscli2 # aws
  ];

  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos_small";
        padding.right = 2;
      };

      display = {
        separator = "  ";
        color = {
          keys = "blue";
          title = "cyan";
        };
      };

      modules = [
        "title"
        "separator"
        {
          type = "os";
          key = "󰣇 OS";
        }
        {
          type = "kernel";
          key = "󰒋 Kernel";
        }
        {
          type = "uptime";
          key = "󰔟 Uptime";
        }
        {
          type = "shell";
          key = " Shell";
        }
        {
          type = "terminal";
          key = " Terminal";
        }
        {
          type = "wm";
          key = " WM";
        }
        {
          type = "cpu";
          key = " CPU";
        }
        {
          type = "gpu";
          key = "󰢮 GPU";
        }
        {
          type = "memory";
          key = " Memory";
        }
        {
          type = "disk";
          key = "󰋊 Disk";
          folders = "/";
        }
      ];
    };
  };
}
