# modules/system.nix — Boot, Nix daemon, locale, networking
{ pkgs, ... }:
{
  # ── Boot ──────────────────────────────────────────────────────────────────
  boot.kernelPackages = pkgs.linuxPackages_latest;
  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;
  zramSwap.enable = true;

  # ── Nix ───────────────────────────────────────────────────────────────────
  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nixpkgs.config.allowUnfree = true;
  nix.gc = {
    automatic = true;
    dates     = "weekly";
    options   = "--delete-older-than 30d";
  };
  programs.nix-ld.enable = true;

  # ── Locale ────────────────────────────────────────────────────────────────
  time.timeZone      = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ADDRESS        = "vi_VN";
    LC_IDENTIFICATION = "vi_VN";
    LC_MEASUREMENT    = "vi_VN";
    LC_MONETARY       = "vi_VN";
    LC_NAME           = "vi_VN";
    LC_NUMERIC        = "vi_VN";
    LC_PAPER          = "vi_VN";
    LC_TELEPHONE      = "vi_VN";
    LC_TIME           = "vi_VN";
  };
  services.xserver.xkb = {
    layout  = "us";
    variant = "";
  };

  # ── Networking ────────────────────────────────────────────────────────────
  networking.hostName              = "thanhvu";
  networking.networkmanager.enable = true;
  services.openssh.enable = true;
  networking.firewall = {
    enable          = true;
    allowedTCPPorts = [ 22 ];
  };

  services.caddy = {
    enable = true;
    virtualHosts = {
      "http://academy.localhost:3000" = {
        extraConfig = "reverse_proxy localhost:3001";
      };
      "http://club.localhost:3000" = {
        extraConfig = "reverse_proxy localhost:3002";
      };
    };
  };

  networking.hosts = {
    "127.0.0.1" = [ "academy.local" "club.local" ];
  };
}
