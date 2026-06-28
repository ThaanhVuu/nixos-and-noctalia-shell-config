# NixOS Config — Context

## Tổng quan

Single-host NixOS flake config cho máy **ASUS TUF F15** (Intel i7 + RTX 3060 Mobile),
chạy **Niri WM** + **Noctalia shell**, với Home Manager quản lý user environment.

```
flake.nix
  └── hosts/thanhvu/default.nix
        ├── hosts/thanhvu/hardware.nix   ← auto-generated, không sửa
        ├── modules/system.nix
        ├── modules/hardware.nix
        ├── modules/desktop.nix
        ├── modules/users.nix
        └── home-manager → home/default.nix
```

---

## flake.nix

Entry point. Khai báo inputs và wire mọi thứ lại.

**Inputs:**
| Input | Source |
|---|---|
| `nixpkgs` | `nixos-unstable` |
| `home-manager` | follows nixpkgs |
| `noctalia` | `noctalia-dev/noctalia` (Quickshell bar) |
| `noctalia-greeter` | `noctalia-dev/noctalia-greeter` (login screen) |
| `fcitx5-lotus` | `LotusInputMethod/fcitx5-lotus` (Vietnamese IME) |

Dùng Cachix binary cache `noctalia.cachix.org` để tránh build noctalia từ source.

**Output:** một `nixosConfiguration` duy nhất tên `nixos`, system `x86_64-linux`.

---

## hosts/thanhvu/

Config riêng cho host này. Nếu sau này thêm máy khác thì tạo `hosts/may-khac/` tương tự.

- **`default.nix`** — import tất cả modules + `fcitx5-lotus.nixosModules`, set `system.stateVersion = "26.05"`.
- **`hardware.nix`** — do `nixos-generate-config` sinh ra, **không sửa tay**. Chứa:
  - kernel modules (xhci, thunderbolt, nvme, ...)
  - filesystem mounts: `/` (ext4), `/boot` (vfat/EFI)
  - 3 NTFS partitions dual-boot Windows: `/mnt/win-c`, `/mnt/win-d`, `/mnt/win-small` — mount lazy với `x-systemd.automount` + `nofail`

---

## modules/system.nix

Boot, Nix daemon, locale, networking.

- **Boot:** `linuxPackages_latest`, systemd-boot, `zramSwap`
- **Nix:** flakes enabled, `allowUnfree`, auto GC weekly (xóa generation > 30 ngày), `nix-ld` (chạy dynamic binary không cần patch)
- **Locale:** timezone `Asia/Ho_Chi_Minh`, UI `en_US.UTF-8`, các `LC_*` set `vi_VN`, keyboard layout `us`
- **Networking:** hostname `thanhvu`, NetworkManager, SSH mở port 22

---

## modules/hardware.nix

Driver và phần cứng.

- **NVIDIA Prime Offload:** Intel iGPU (`PCI:0:2:0`) chạy chính, RTX 3060 (`PCI:1:0:0`) offload theo yêu cầu. Driver `stable`, `open = true` (open-source kernel module). VAAPI driver nvidia cho hardware decode.
- **Audio:** PipeWire + ALSA + PulseAudio compat + rtkit. Bluetooth bật. `power-profiles-daemon` + `upower`.
- **Storage:** NTFS support (`ntfs3g`), GVfs, udisks2, Polkit, dconf, `programs.niri.useNautilus`. udev rules expose 3 Windows NTFS partitions vào Nautilus sidebar (`UDISKS_AUTO=1`).

---

## modules/desktop.nix

WM, greeter, input method.

- **Niri WM:** `programs.niri.enable = true`
- **Noctalia Greeter:** login screen lấy package từ flake input
- **Fcitx5 + Lotus:** Vietnamese IME qua `services.fcitx5-lotus`, addon `fcitx5-gtk` + `fcitx5-qt` + `fcitx5-lotus`. Session variables `GTK_IM_MODULE`, `QT_IM_MODULE`, `XMODIFIERS`, `SDL_IM_MODULE` đều set `fcitx`.

---

## modules/users.nix

User, shell, Docker.

- **User `thanhvu`:** groups `networkmanager` + `wheel` (sudo), default shell Fish
- **Fish:** `programs.fish.enable = true` ở system level (bắt buộc khi dùng Fish làm login shell)
- **Docker rootless:** `virtualisation.docker.rootless`, kernel module `overlay`, cài `docker-compose` + `docker-buildx`. Aliases: `dc`, `dps`.

---

## home/default.nix

Home Manager — quản lý user-level packages và dotfiles.

**Packages cài:**
- Dev tools: `git`, `fnm`, `pnpm`, `vscode`, `jetbrains.webstorm`, `bruno`
- Terminal: `kitty`, `fish`, `starship`, `fastfetch`, `btop`
- Apps: `firefox`, `nautilus`, `p7zip`, `python3`, `tree`
- Font: `nerd-fonts.jetbrains-mono`

**Fish config:**
- `fastfetch` + `starship` khởi động cùng shell
- pnpm PATH (`~/.local/share/pnpm`)
- fnm auto-use Node version theo `.nvmrc`/`.node-version`
- Aliases: `nix-rebuild`, `nix-garbage`, `nix-edit`, `niri-edit`

**Noctalia shell:** `programs.noctalia.enable = true` (Quickshell/QML bar)

**Cursor:** Bibata-Modern-Ice size 24

**udiskie:** auto-mount removable drives

---

## Các lệnh thường dùng

```bash
# Rebuild
sudo nixos-rebuild switch --flake ~/nixos#nixos
# hoặc alias:
nix-rebuild

# GC
nix-garbage

# Edit config
nix-edit       # mở ~/nixos trong VSCode
niri-edit      # mở ~/.config/niri trong VSCode

# Chạy app bằng RTX
nvidia-offload <app>

# Docker
dc up -d       # docker compose up -d
dps            # docker ps
```
