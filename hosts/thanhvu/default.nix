# hosts/thanhvu/default.nix — entry point
{ inputs, ... }:
{
  imports = [
    ./hardware.nix

    ../../modules/system.nix
    ../../modules/hardware.nix
    ../../modules/desktop.nix
    ../../modules/users.nix

    inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
  ];

  system.stateVersion = "26.05";
}
