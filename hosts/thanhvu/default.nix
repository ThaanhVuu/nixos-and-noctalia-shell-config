# hosts/thanhvu/default.nix — entry point
#
# Đây là "công tắc tổng": mọi module đang BẬT cho máy này phải có mặt trong
# danh sách imports dưới đây. Muốn tắt tính năng gì → comment dòng tương ứng.
# Muốn biết file nào chứa gì → xem context.md (bảng tra nhanh).
{ inputs, ... }:
{
  imports = [
    ./hardware.nix   # auto-generated, KHÔNG sửa tay

    # ── Core hệ thống ─────────────────────────────────────────
    ../../modules/core/boot.nix
    ../../modules/core/nix.nix
    ../../modules/core/locale.nix
    ../../modules/core/networking.nix

    # ── Phần cứng ─────────────────────────────────────────────
    ../../modules/hardware/gpu.nix
    ../../modules/hardware/audio.nix
    ../../modules/hardware/storage.nix

    # ── Dịch vụ chạy nền ──────────────────────────────────────
    ../../modules/services/docker.nix
    ../../modules/services/ollama.nix

    # ── Desktop / WM ──────────────────────────────────────────
    ../../modules/desktop/niri.nix
    ../../modules/desktop/greeter.nix
    ../../modules/desktop/input-method.nix
    
    # ── User ──────────────────────────────────────────────────
    ../../modules/users.nix
  ];

  system.stateVersion = "26.05";
}
