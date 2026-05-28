{ pkgs, ... }:
{
  fonts = {
    enableDefaultPackages = true;
    packages = with pkgs; [
      nerd-fonts.fira-code
      nerd-fonts.symbols-only
    ];
    fontconfig.defaultFonts.monospace = [ "FiraCode Nerd Font Mono" ];
  };
}
