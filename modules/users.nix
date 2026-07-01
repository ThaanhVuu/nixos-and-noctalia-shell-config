# modules/users.nix — user account "thanhvu" + Fish là login shell
{ pkgs, ... }:
{
  users.users.thanhvu = {
    isNormalUser = true;
    description  = "thanhvu";
    extraGroups  = [ "networkmanager" "wheel" ];
    shell        = pkgs.fish;
  };
  programs.fish.enable = true;
}
