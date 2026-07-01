# modules/core/networking.nix — hostname, NetworkManager, SSH, firewall,
# Caddy reverse proxy cho local dev domain (academy.local, club.local)
{ ... }:
{
  networking.hostName              = "thanhvu";
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  networking.firewall = {
    enable          = true;
    allowedTCPPorts = [ 22 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://academy.localhost:3000" = {
        extraConfig = "reverse_proxy localhost:3001";
      };
      "http://club.localhost:3000" = {
        extraConfig = "reverse_proxy localhost:3002";
      };
    };
  };

  networking.hosts = {
    "127.0.0.1" = [ "academy.local" "club.local" ];
  };
}
