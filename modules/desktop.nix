# modules/desktop.nix — Niri WM, Noctalia greeter, Fcitx5 input method
{ pkgs, inputs, ... }:
{
  # ── Niri WM + Noctalia greeter ────────────────────────────────────────────
  programs.niri.enable = true;
  programs.noctalia-greeter = {
    enable  = true;
    package = inputs.noctalia-greeter.packages.${pkgs.stdenv.hostPlatform.system}.default;
  };

  # ── Fcitx5 input method ───────────────────────────────────────────────────
  services.fcitx5-lotus = {
    enable = true;
    users  = [ "thanhvu" ];
  };
  i18n.inputMethod = {
    enable = true;
    type   = "fcitx5";
    fcitx5.addons = with pkgs; [
      fcitx5-gtk
      libsForQt5.fcitx5-qt
      inputs.fcitx5-lotus.packages.${pkgs.system}.fcitx5-lotus
    ];
  };
  environment.sessionVariables = {
    GTK_IM_MODULE = "fcitx";
    QT_IM_MODULE  = "fcitx";
    XMODIFIERS    = "@im=fcitx";
    SDL_IM_MODULE = "fcitx";
  };
}
