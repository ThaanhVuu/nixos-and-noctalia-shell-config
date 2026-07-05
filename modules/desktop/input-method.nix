# modules/desktop/input-method.nix — Fcitx5 + Lotus (bộ gõ tiếng Việt)
{ pkgs, inputs, ... }:
{
    imports = [
        inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
    ];

    # Bật fcitx5 làm input method của hệ thống (set GTK_IM_MODULE, QT_IM_MODULE,
    # XMODIFIERS, autostart...). Thiếu đoạn này thì Lotus có cài cũng vô nghĩa.
    i18n.inputMethod = {
        enable = true;
        type = "fcitx5";
        fcitx5.waylandFrontend = true;
        fcitx5.addons = with pkgs; [ fcitx5-gtk qt6Packages.fcitx5-configtool ];
    };

    # Cài package fcitx5-lotus + bật service nền (lotus-server) cho user.
    services.fcitx5-lotus = {
        enable = true;
        users = [ "thanhvu" ]; # Sửa thành list tên user của bạn
    };
}