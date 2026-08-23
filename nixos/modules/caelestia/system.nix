{ pkgs, ... }:
{
  # GNOME and GDM remain enabled by desktop.nix. Hyprland appears as an
  # additional session in GDM.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  };

  security.polkit.enable = true;
  security.pam.services.caelestia = { };

  programs.ydotool.enable = true;
  users.users.td.extraGroups = [ "ydotool" ];

  services.gnome.gnome-keyring.enable = true;
  services.power-profiles-daemon.enable = true;
  hardware.bluetooth.enable = true;
}
