# modules/desktop/greeter.nix — Noctalia greeter (màn hình login)
{ pkgs, inputs, ... }:
{
  programs.noctalia-greeter = {
    enable  = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };
}
