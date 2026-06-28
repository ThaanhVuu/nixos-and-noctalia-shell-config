# modules/users.nix — User accounts, Fish shell, rootless Docker
{ pkgs, ... }:
{
  # ── User ──────────────────────────────────────────────────────────────────
  users.users.thanhvu = {
    isNormalUser = true;
    description  = "thanhvu";
    extraGroups  = [ "networkmanager" "wheel" ];
    shell        = pkgs.fish;
  };
  programs.fish.enable = true;

  # ── Docker (rootless) ─────────────────────────────────────────────────────
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
