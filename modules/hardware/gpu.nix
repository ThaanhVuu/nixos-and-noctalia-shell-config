# modules/hardware/gpu.nix — NVIDIA Prime offload
# Intel iGPU (PCI:0:2:0) chạy chính, RTX 3060 Mobile (PCI:1:0:0) offload theo yêu cầu
{ config, pkgs, ... }:
{
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
}
