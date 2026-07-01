# modules/hardware/audio.nix — PipeWire, Bluetooth, power management
{ ... }:
{
  security.rtkit.enable = true;
  services.pipewire = {
    enable       = true;
    alsa.enable  = true;
    pulse.enable = true;
  };
  hardware.bluetooth.enable             = true;
  services.power-profiles-daemon.enable = true;
  services.upower.enable                = true;
}
