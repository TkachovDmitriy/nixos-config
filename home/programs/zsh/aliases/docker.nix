{ ... }:
{
  programs.zsh.shellAliases = {
    d      = "docker";
    dc     = "docker compose";
    dcu    = "docker compose up";
    dcud   = "docker compose up -d";
    dcd    = "docker compose down";
    dcl    = "docker compose logs -f";
    dps    = "docker ps";
    dpsa   = "docker ps -a";
    di     = "docker images";
    dex    = "docker exec -it";
    dlog   = "docker logs -f";
    dprune = "docker system prune -af";
    dvp    = "docker volume prune";
  };
}
