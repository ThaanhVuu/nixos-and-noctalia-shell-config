# home/default.nix — Home Manager: packages, shell, desktop
{ pkgs, inputs, ... }:
{
  imports = [
    inputs.noctalia.homeModules.default
  ];

  # ── Packages ──────────────────────────────────────────────────────────────
  home.packages = with pkgs; [
    jetbrains.idea
    tree
    p7zip
    python3
    nerd-fonts.jetbrains-mono
    starship
    kitty
    firefox
    vscode
    jetbrains.webstorm
    git
    fnm
    bruno
    fastfetch
    btop
    nautilus
    kitty
  ];

  # ── Fish shell ────────────────────────────────────────────────────────────
  programs.fish = {
    enable = true;
    shellAliases = {
      nix-rebuild = "sudo nixos-rebuild switch --flake ~/nixos#nixos";
      nix-garbage  = "sudo nix-env --delete-generations +1 --profile /nix/var/nix/profiles/system && sudo nix-collect-garbage";
      nix-edit = "code ~/nixos";
      niri-edit = "code ~/.config/niri";
    };
    interactiveShellInit = ''
      fastfetch
      starship init fish | source
      
      # fnm
      fnm env --use-on-cd --shell fish | source
    '';
  };

  home.sessionVariables = {
    PNPM_HOME = "$HOME/.local/share/pnpm";
    JAVA_HOME = "${pkgs.jdk11}";
  };
  
  home.sessionPath = [
    "$HOME/.local/share/pnpm"
    "$HOME/.local/share/pnpm/bin"
  ];
  
  # ── Noctalia (Quickshell/QML bar) ─────────────────────────────────────────
  programs.noctalia = {
    enable = true;
    # settings.general.lockOnSuspend = true;
  };

  # ── Cursor ────────────────────────────────────────────────────────────────
  home.pointerCursor = {
    gtk.enable = true;
    package    = pkgs.bibata-cursors;
    name       = "Bibata-Modern-Ice";
    size       = 24;
  };

  services.udiskie.enable = true;
  home.username      = "thanhvu";
  home.homeDirectory = "/home/thanhvu";
  home.stateVersion  = "26.05";
}
