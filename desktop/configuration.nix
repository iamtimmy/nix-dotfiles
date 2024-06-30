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
  chaotic.scx.enable = true;
  powerManagement.cpuFreqGovernor = "performance";
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

  boot.kernel.sysctl = {
    "kernel.unprivileged_userns_clone" = 1;
  };
  
  boot.loader = {
    efi.canTouchEfiVariables = true;
    # systemd-boot.enable = true;

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
    };
  };

  hardware.cpu.amd.updateMicrocode = true;

  boot.initrd.luks.devices."luks-45def02a-8897-4505-8902-8d0f49205a82".device = "/dev/disk/by-uuid/45def02a-8897-4505-8902-8d0f49205a82";

  networking.hostName = "desktop";
  networking.networkmanager.enable = true;
  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver = {
    enable = true;
    displayManager = {
      sddm = {
        enable = true;
        theme = "tokyo-night-sddm";
        wayland.enable = true;
      };
    };
    desktopManager.gnome.enable = true;
  };

  programs.dconf.enable = true;
  
  xdg = {
    sounds.enable = true;
    portal.enable = true;

    portal.xdgOpenUsePortal = true;
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
    systemWide = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    wireplumber.enable = true;
    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.rate = 48000;
        default.clock.quantum = 64;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 64;
      };
    };
    extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min_req = "32/48000";
            pulse.default.req = "64/48000";
            pulse.max.req = "64/48000";
            pulse.min.quantum = "32/48000";
            pulse.max_quantum = "64/48000";
          };
        
        }
      ];
      steam.properties = {
        node.latency = "64/48000";
        resample.quality = 1;
      };
    };
  };

  # enable 3d acceleration
  hardware.opengl = {
    enable = true;
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
      "jackaudio"
      "video"
      "media"
      "pipewire"
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
  nix.settings.cores = 8;
  nix.settings.max-jobs = 3;

  programs.virt-manager.enable = true;
  programs.adb.enable = true;

  programs.hyprland.enable = true;
  programs.hyprland.xwayland.enable = true;
  # programs.hyprland.package = pkgs.hyprland.override { debug = true; };

  programs.steam.enable = true;
  programs.steam.protontricks.enable = true;
  programs.steam.gamescopeSession.enable = true;
  programs.steam.extest.enable = true;
  programs.steam.extraCompatPackages = with pkgs; [
    proton-ge-bin
  ];

  services.flatpak.enable = true;
  
  programs.gamescope.enable = true;
  programs.firejail.enable = true;

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 10";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
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

    xwaylandvideobridge
    pavucontrol
    helvum

    steam-run
    wine
    wineasio
    winetricks
    wineWowPackages.waylandFull

    gnome.adwaita-icon-theme

    edk2-uefi-shell
  ];

  environment.sessionVariables = {
    FLAKE = "$HOME/dotfiles";
    NIXOS_OZONE_WL = "1";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CONFIG_DIR = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    LIBVA_DRIVER_NAME = "nvidia";
    GBM_BACKEND = "nvidia-drm";
    __GLX_VENDOR_TYPE_LIBRARY_NAME = "nvidia";
    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";

    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
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
