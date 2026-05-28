{ pkgs, ... }:
{
  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
    # base
    stdenv.cc.cc.lib
    zlib
    openssl
    curl
    glib

    # playwright chromium
    nss
    nspr
    atk
    at-spi2-atk
    at-spi2-core
    cups
    dbus
    expat
    libdrm
    libX11
    libXcomposite
    libXdamage
    libXext
    libXfixes
    libXrandr
    libxcb
    libxkbcommon
    mesa
    pango
    cairo
    alsa-lib
    gtk3
    gdk-pixbuf

    # supabase cli
    glibc
  ];
}
