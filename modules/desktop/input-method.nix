# modules/desktop/input-method.nix — Fcitx5 + Lotus (bộ gõ tiếng Việt)
{ pkgs, inputs, ... }:
{
    imports = [
        inputs.fcitx5-lotus.nixosModules.fcitx5-lotus
    ];

    services.fcitx5-lotus = {
        enable = true;
        users = [ "thanhvu" ]; # Sửa thành list tên user của bạn
    };
}
