# modules/core/nix.nix — Nix daemon: flakes, GC, unfree, nix-ld
{ ... }:
{
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };
  programs.nix-ld.enable = true;
}
