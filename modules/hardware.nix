# modules/hardware.nix — NVIDIA, audio (PipeWire), storage (NTFS, udisks2)
{ config, pkgs, ... }:
{
  # ── NVIDIA (Prime offload, Intel iGPU chính) ──────────────────────────────
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.nvidia = {
    modesetting.enable     = true;
    powerManagement.enable = false;
    open                   = true;
    nvidiaSettings         = true;
    package                = config.boot.kernelPackages.nvidiaPackages.stable;
    prime = {
      offload = {
        enable           = true;
        enableOffloadCmd = true;
      };
      intelBusId  = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  hardware.graphics = {
    enable        = true;
    enable32Bit   = true;
    extraPackages = with pkgs; [ nvidia-vaapi-driver ];
  };
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME         = "nvidia";
    __GLX_VENDOR_LIBRARY_NAME = "nvidia";
  };

  # ── Audio (PipeWire + Bluetooth) ──────────────────────────────────────────
  security.rtkit.enable = true;
  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable             = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable                = true;

  # ── Storage (NTFS, GVfs, udisks2, Nautilus) ───────────────────────────────
  boot.supportedFilesystems  = [ "ntfs" ];
  environment.systemPackages = with pkgs; [ ntfs3g ];
  services.gvfs.enable       = true;
  services.udisks2.enable    = true;
  security.polkit.enable     = true;
  programs.dconf.enable      = true;
  programs.niri.useNautilus  = true;
  environment.pathsToLink    = [ "/share/glib-2.0" ];

  # Hiển thị NTFS dual-boot trong Nautilus sidebar
  services.udev.extraRules = ''
    ENV{ID_FS_UUID}=="F2C07986C07951B9", ENV{UDISKS_SYSTEM}="0", ENV{UDISKS_AUTO}="1"
    ENV{ID_FS_UUID}=="25B569AE0C63D6C1", ENV{UDISKS_SYSTEM}="0", ENV{UDISKS_AUTO}="1"
    ENV{ID_FS_UUID}=="17C1242D58741CE1", ENV{UDISKS_SYSTEM}="0", ENV{UDISKS_AUTO}="1"
  '';
}
