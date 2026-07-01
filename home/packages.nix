# home/packages.nix — user-level packages, env vars, PATH
{ pkgs, ... }:
{
  home.packages = with pkgs; [
    # Dev tools
    git
    fnm
    vscode
    jetbrains.webstorm
    jetbrains.idea
    bruno

    # Terminal
    kitty
    starship
    fastfetch
    btop

    # Apps
    firefox
    nautilus
    p7zip
    python3
    tree

    # Font
    nerd-fonts.jetbrains-mono
  ];

  home.sessionVariables = {
    PNPM_HOME = "$HOME/.local/share/pnpm";
    JAVA_HOME = "${pkgs.jdk11}";
  };

  home.sessionPath = [
    "$HOME/.local/share/pnpm"
    "$HOME/.local/share/pnpm/bin"
  ];
}
