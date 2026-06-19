{ hunk, system, ... }:
{
  home.packages = [
    hunk.packages.${system}.default
  ];
}
