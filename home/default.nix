# home/default.nix — Home Manager entry point
{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default

    ./packages.nix
    ./shell.nix
    ./desktop.nix
  ];

  home.username      = "thanhvu";
  home.homeDirectory = "/home/thanhvu";
  home.stateVersion  = "26.05";
}
