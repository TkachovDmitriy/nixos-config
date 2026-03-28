{ pkgs, ... }:
{
  services.xserver.enable = true;

  # Нові правильні шляхи (не через xserver)
  services.displayManager.gdm.enable   = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout  = "us,ua";
    variant = "";
    options = "grp:alt_shift_toggle";
  };

  environment.gnome.excludePackages = with pkgs; [
    gnome-terminal
  ];

  programs.appimage.enable = true;
  programs.appimage.binfmt = true;
}
