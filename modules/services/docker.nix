# modules/services/docker.nix — Docker rootless
{ pkgs, ... }:
{
  virtualisation.docker.rootless = {
    enable            = true;
    setSocketVariable = true;
  };
  boot.kernelModules = [ "overlay" ];
  environment.systemPackages = with pkgs; [
    docker-compose
    docker-buildx
  ];
  environment.shellAliases = {
    dc  = "docker compose";
    dps = "docker ps";
  };
}
