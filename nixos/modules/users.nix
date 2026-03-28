{ pkgs, ... }:
{
  programs.zsh.enable = true;

  users.users.td = {
    isNormalUser = true;
    description  = "Tiny Dev";
    extraGroups  = [ "networkmanager" "wheel" "docker" ];
    shell        = pkgs.zsh;
  };

  programs.firefox.enable = true;
}
