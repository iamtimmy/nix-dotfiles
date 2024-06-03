{ config, pkgs, inputs, ... }:

let
  tokyo-night-sddm = pkgs.libsForQt5.callPackage ./tokyo-night-sddm.nix {};
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      inputs.home-manager.nixosModules.default
    ];

  # Bootloader.
  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  boot.supportedFilesystems = [ "ntfs" ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
  ];

  boot.kernelModules = [
    # Virtual Camera
    "v4l2loopback"
    # Virtual Microphone, built-in
    "sdn-aloop"
  ];

  boot.initrd.kernelModules = [
    "nvidia"
    "nvidia_modeset"
    "nvidia_uvm"
    "nvidia_drm"
  ];

  boot.extraModprobeConfig = ''
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';

  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
    "nvidia_drm.modeset=1"
  ];

  boot.blacklistedKernelModules = [
    "amdgpu"
    "snd_hda_intel"
  ];
  
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  hardware.cpu.amd.updateMicrocode = true;

  boot.initrd.luks.devices."luks-45def02a-8897-4505-8902-8d0f49205a82".device = "/dev/disk/by-uuid/45def02a-8897-4505-8902-8d0f49205a82";

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    # enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "tokyo-night-sddm";
        wayland.enable = true;
      };
    };
  };

  xdg = {
    sounds.enable = true;
    portal.enable = true;
  };

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  # Enable sound with pipewire.
  sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
  };

  # enable 3d acceleration
  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
    extraPackages = with pkgs; [
      vaapiVdpau
      libvdpau-va-gl
    ];
  };
  
  services.xserver.videoDrivers = ["nvidia"];
  hardware.nvidia.nvidiaSettings = true;
  hardware.nvidia.powerManagement.enable = false;
  hardware.nvidia.powerManagement.finegrained = false;
  hardware.nvidia.modesetting.enable = true;
  hardware.nvidia.open = false;

  # mouse config service
  services.ratbagd.enable = true;

  # define user
  users.users.user = {
    isNormalUser = true;
    description = "user";
    extraGroups = [
      "wheel"
      "networkmanager"

      "input"
      "audio"
      "video"
      "media"
      "adbusers"
    ];
    packages = with pkgs; [
      firefox
    ];
  };

  home-manager = {
    extraSpecialArgs = { inherit inputs; };
    users = {
      "user" = import ../home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  programs.virt-manager.enable = true;
  programs.adb.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;

  programs.steam.enable = true;
  programs.gamescope.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 10";
    flake = "/home/user/dotfiles";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    kitty
    helix
    git
    gh
    lf
    ripgrep
    lshw
    pciutils

    # sddm theme
    tokyo-night-sddm

    swww
    waybar
    rofi-wayland
    dolphin
    mako
    hyprshot
    satty
    wl-clipboard
    wl-clip-persist
    cliphist
    libnotify
    libsForQt5.polkit-kde-agent

    steam-run
  ];

  environment.sessionVariables = {
    FLAKE = "/home/user/dotfiles";
    NIXOS_OZONE_WL = "1";
  };

  services.power-profiles-daemon.enable = true;
  services.dbus.enable = true;
  services.gvfs.enable = true;

  fonts = {
    fonts = with pkgs; [
      fira
      (nerdfonts.override {
        fonts = [
          "JetBrainsMono"
        ];
      })
      noto-fonts
      noto-fonts-cjk
      noto-fonts-emoji
    ];

    fontconfig = {
      cache32Bit = true;
      defaultFonts = {
        emoji = ["Noto Color Emoji"];
        monospace = [ "JetBrains Mono Nerd Font" "Noto Fonts Emoji" ];
        sansSerif = [ "Fira" "Noto Fonts Emoji" ];
        serif = [ "Fira" "Noto Fonts Emoji" ];
      };
      enable = true;
    };

    fontDir = {
      enable = true;
      decompressFonts = true;
    };
  };

  disabledModules = ["programs.hyprland.nix"];

  system.stateVersion = "23.11";
}
