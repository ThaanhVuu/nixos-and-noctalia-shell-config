# NixOS Config — Bản đồ

Máy **ASUS TUF F15** (Intel i7 + RTX 3060 Mobile), **Niri WM** + **Noctalia shell**,
Home Manager quản lý user environment.

---

## Tra nhanh: muốn sửa gì → mở file nào

| Muốn sửa...                                       | File                                  |
|----------------------------------------------------|----------------------------------------|
| Bootloader, kernel, swap                            | `modules/core/boot.nix`                |
| Nix daemon: flakes, GC, allowUnfree, nix-ld         | `modules/core/nix.nix`                 |
| Timezone, locale, layout bàn phím                   | `modules/core/locale.nix`              |
| Hostname, SSH, firewall, Caddy reverse proxy        | `modules/core/networking.nix`          |
| Driver NVIDIA, Prime offload                        | `modules/hardware/gpu.nix`             |
| Audio (PipeWire), Bluetooth                         | `modules/hardware/audio.nix`           |
| NTFS, mount ổ Windows, Nautilus                     | `modules/hardware/storage.nix`         |
| Docker                                              | `modules/services/docker.nix`          |
| Ollama / local LLM                                  | `modules/services/ollama.nix`          |
| Niri WM                                             | `modules/desktop/niri.nix`             |
| Màn hình login (Noctalia greeter)                   | `modules/desktop/greeter.nix`          |
| **Bộ gõ tiếng Việt (Fcitx5 + Lotus)**                | `modules/desktop/input-method.nix`     |
| User account, shell mặc định                        | `modules/users.nix`                    |
| Bật/tắt module nào đang active                      | `hosts/thanhvu/default.nix`            |
| Thêm/bớt flake input (repo nguồn)                    | `flake.nix`                            |
| Package cài cho user, JAVA_HOME, PNPM PATH           | `home/packages.nix`                    |
| Alias, cấu hình Fish shell                           | `home/shell.nix`                       |
| Noctalia shell (bar), cursor theme                   | `home/desktop.nix`                     |
| `hardware.nix` (auto-gen)                            | **không sửa tay**, do `nixos-generate-config` sinh |

Không nhớ nằm đâu → `rg -l "tên_thứ_cần_tìm" ~/nixos` (alias `nix-find`, xem cuối file).

---

## Sơ đồ cây

```
flake.nix
home/
  default.nix          # entry point, import 3 file dưới
  packages.nix          # packages, PNPM_HOME, JAVA_HOME
  shell.nix              # Fish: alias, startup
  desktop.nix            # Noctalia shell, cursor, udiskie
hosts/thanhvu/
  default.nix            # entry point — LIST TOÀN BỘ MODULE ĐANG BẬT
  hardware.nix            # auto-generated, không sửa
modules/
  users.nix
  core/
    boot.nix
    nix.nix
    locale.nix
    networking.nix
  hardware/
    gpu.nix
    audio.nix
    storage.nix
  services/
    docker.nix
    ollama.nix
  desktop/
    niri.nix
    greeter.nix
    input-method.nix
```

**Nguyên tắc:** 1 file = 1 concern. Tên file = đúng thứ nó chứa, không cần đoán.
`hosts/thanhvu/default.nix` là công tắc tổng — đọc file này là biết ngay
những gì đang bật và path của từng cái, không cần nhớ.

---

## flake.nix — inputs

| Input | Source |
|---|---|
| `nixpkgs` | `nixos-unstable` |
| `home-manager` | follows nixpkgs |
| `noctalia` | `noctalia-dev/noctalia` (Quickshell bar) |
| `noctalia-greeter` | `noctalia-dev/noctalia-greeter` (login screen) |
| `fcitx5-lotus` | `LotusInputMethod/fcitx5-lotus` (Vietnamese IME) |

Cachix `noctalia.cachix.org` để tránh build noctalia từ source.
Output: 1 `nixosConfiguration` tên `nixos`, system `x86_64-linux`.

---

## Ghi chú riêng từng phần

**`modules/core/networking.nix`** — ngoài SSH/firewall còn có Caddy reverse proxy
cho 2 domain dev local: `academy.local` → `:3001`, `club.local` → `:3002`.

**`modules/hardware/gpu.nix`** — Intel iGPU (`PCI:0:2:0`) chạy chính, RTX 3060
(`PCI:1:0:0`) offload theo yêu cầu qua `nvidia-offload <app>`. Driver `stable`,
`open = true` (kernel module open-source).

**`modules/hardware/storage.nix`** — udev rules hard-code UUID của 3 partition
NTFS dual-boot Windows để hiện trong Nautilus sidebar. Nếu cài lại Windows /
đổi ổ cứng, UUID sẽ đổi → phải cập nhật lại 3 dòng UUID trong file này
(chạy `lsblk -f` để lấy UUID mới).

**`modules/services/ollama.nix`** — chạy qua CUDA, ép offload qua RTX 3060
bằng biến `__NV_PRIME_RENDER_OFFLOAD`. Nếu đổi model / cần thêm VRAM config,
sửa `OLLAMA_NUM_GPU` ở đây.

**`modules/desktop/input-method.nix`** — bộ gõ tiếng Việt Fcitx5 + Lotus.
Input `fcitx5-lotus` được khai báo ở `flake.nix`, và module NixOS của nó
(`inputs.fcitx5-lotus.nixosModules.fcitx5-lotus`) được import riêng trong
`hosts/thanhvu/default.nix` (không nằm trong `modules/`, vì đó là module
tới từ flake input, không phải module tự viết).

---

## Các lệnh thường dùng

```bash
# Rebuild
sudo nixos-rebuild switch --flake ~/nixos#nixos
nix-rebuild          # alias

# GC
nix-garbage

# Edit config
nix-edit              # mở ~/nixos trong VSCode
niri-edit              # mở ~/.config/niri trong VSCode

# Tìm nhanh 1 setting nằm ở file nào
nix-find "từ_khoá"          # alias, = rg -l --type nix ~/nixos

# Chạy app bằng RTX
nvidia-offload <app>

# Docker
dc up -d
dps
```
