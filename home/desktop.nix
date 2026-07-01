# home/desktop.nix — Noctalia shell (Quickshell/QML bar), cursor theme, udiskie
{ pkgs, ... }:
{
  programs.noctalia = {
    enable = true;
    # settings.general.lockOnSuspend = true;
  };

  home.pointerCursor = {
    gtk.enable = true;
    package    = pkgs.bibata-cursors;
    name       = "Bibata-Modern-Ice";
    size       = 24;
  };

  services.udiskie.enable = true;
}
