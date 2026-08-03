{ pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    # Gaming / Wine — Project Ascension launcher
    lutris
    wineWow64Packages.stableFull   # Wine 11 (64+32-bit)
    winetricks
    dxvk
  ];

  # 32-bit graphics — required for the WoW client
  hardware.graphics.enable = true;
  hardware.graphics.enable32Bit = true;
}
