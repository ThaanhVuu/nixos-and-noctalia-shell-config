# home/shell.nix — Fish: aliases, startup script
{ ... }:
{
  programs.fish = {
    enable = true;
    shellAliases = {
      nix-rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      nix-garbage = "sudo nix-env --delete-generations +1 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage";
      nix-edit    = "code ~/nixos";
      niri-edit   = "code ~/.config/niri";
      nix-find    = "rg -l --type nix";
    };
    interactiveShellInit = ''
      fastfetch
      starship init fish | source

      # fnm
      fnm env --use-on-cd --shell fish | source
    '';
  };
}
