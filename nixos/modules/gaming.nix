{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Gaming / Wine — Project Ascension launcher
    lutris
    wineWow64Packages.stableFull # Wine 11 (64+32-bit)
    winetricks
    dxvk
    gamescope
  ];

  # 32-bit graphics — required for the WoW client
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;

  # Feral GameMode — better CPU governor / lower latency while gaming
  programs.gamemode.enable = true;

  # Gamescope — micro-compositor that fixes XWayland cursor flicker/scaling
  # in Wine games under Wayland; provides a setcap wrapper for realtime priority
  programs.gamescope.enable = true;
}
