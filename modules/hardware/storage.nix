# modules/hardware/storage.nix — NTFS, GVfs/udisks2, dual-boot Windows
# partitions hiện trong Nautilus sidebar
{ pkgs, ... }:
{
  boot.supportedFilesystems  = [ "ntfs" ];
  environment.systemPackages = with pkgs; [ ntfs3g ];
  services.gvfs.enable       = true;
  services.udisks2.enable    = true;
  security.polkit.enable     = true;
  programs.dconf.enable      = true;
  programs.niri.useNautilus  = true;
  environment.pathsToLink    = [ "/share/glib-2.0" ];

  # 3 partition NTFS dual-boot (win-c, win-d, win-small) — hiện trong sidebar
  services.udev.extraRules = ''
    ENV{ID_FS_UUID}=="F2C07986C07951B9", ENV{UDISKS_SYSTEM}="0", ENV{UDISKS_AUTO}="1"
    ENV{ID_FS_UUID}=="25B569AE0C63D6C1", ENV{UDISKS_SYSTEM}="0", ENV{UDISKS_AUTO}="1"
    ENV{ID_FS_UUID}=="17C1242D58741CE1", ENV{UDISKS_SYSTEM}="0", ENV{UDISKS_AUTO}="1"
  '';
}
