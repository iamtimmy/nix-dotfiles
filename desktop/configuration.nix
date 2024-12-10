{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix

      ../modules/amd-gpu.nix
      ../modules/wayland.nix
      ../modules/hyprland.nix
    ];

  # Kernel and Bootloader options
  boot.loader = {
    efi.canTouchEfiVariables = true;

    grub = {
      enable = true;
      devices = [ "nodev" ];
      efiSupport = true;
      useOSProber = true;
      configurationLimit = 3;
    };
  };

  boot.kernelPackages = pkgs.linuxPackages_cachyos;
  
  boot.tmp.cleanOnBoot = true;

  boot.supportedFilesystems = [ "ntfs" ];

  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"
  ];

  boot.extraModulePackages = with config.boot.kernelPackages; [
    v4l2loopback.out
  ];

  boot.kernelModules = [
    # Virtual Camera
    "v4l2loopback"
    # Virtual Microphone, built-in
    "sdn-aloop"
  ];

  boot.extraModprobeConfig = ''
    # https://github.com/umlaeute/v4l2loopback
    options v4l2loopback exclusive_caps=1 card_label="Virtual Camera"
  '';



  hardware.cpu.amd.updateMicrocode = true;




  networking.hostName = "desktop";
  networking.networkmanager.enable = true;

  hardware.bluetooth.enable = true;
  hardware.bluetooth.powerOnBoot = true;
  services.blueman.enable = true;

  time.hardwareClockInLocalTime = true;
  time.timeZone = "Europe/Amsterdam";
  i18n.defaultLocale = "en_US.UTF-8";

  amd-gpu-config.enable = true;
  wayland-config.enable = true;
  hyprland-config.enable = true;

  # services.displayManager = {
  #   sddm = {
  #     enable = true;
  #     wayland.enable = true;
  #   };

  #   defaultSession = "hyprland";
  # };

  # services.xserver = {
  #   enable = true;
  #   desktopManager = {
  #     xterm.enable = false;
  #     xfce.enable = true;
  #   };
  # };

  # services.libinput.mouse = {
  #   accelProfile = "flat";
  # };

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
  security.rtkit.enable = true;
  security.polkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;
    # systemWide = true;

    extraConfig.pipewire."92-low-latency" = {
      context.properties = {
        default.clock.allowed-rates = [ 48000 96000 192000 ];
        default.clock.rate = 192000;
        default.clock.quantum = 256;
        default.clock.min-quantum = 32;
        default.clock.max-quantum = 2048;
      };
    };
    extraConfig.pipewire-pulse."92-low-latency" = {
      context.modules = [
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            pulse.min.req = "32/192000";
            pulse.default.req = "256/192000";
            pulse.max.req = "2048/192000";
            pulse.min.quantum = "32/192000";
            pulse.max.quantum = "2048/192000";
          };
        }
      ];
      stream.properties = {
        node.latency = "256/192000";
        resample.quality = 1;
      };
    };

    extraConfig.pipewire."91-null-sinks" = {
      "context.objects" = [
        {
          # A default dummy driver. This handles nodes marked with the "node.always-driver"
          # properyty when no other driver is currently active. JACK clients need this.
          factory = "spa-node-factory";
          args = {
            "factory.name"     = "support.node.driver";
            "node.name"        = "Dummy-Driver";
            "priority.driver"  = 8000;
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name"     = "support.null-audio-sink";
            "node.name"        = "Microphone-Proxy";
            "node.description" = "Microphone";
            "media.class"      = "Audio/Source/Virtual";
            "audio.position"   = "MONO";
          };
        }
        {
          factory = "adapter";
          args = {
            "factory.name"     = "support.null-audio-sink";
            "node.name"        = "Main-Output-Proxy";
            "node.description" = "Main Output";
            "media.class"      = "Audio/Sink";
            "audio.position"   = "FL,FR";
          };
        }
      ];
    };
  };
  
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
    ];
  };

  home-manager = {
    useUserPackages = true;
    useGlobalPkgs = true;
    backupFileExtension = "backup";
    extraSpecialArgs = { inherit inputs; };
    users = {
      "user" = import ./home.nix;
    };
  };

  # Allow unfree packages
  nixpkgs.config.allowUnfree = true;

  nix.settings.experimental-features = [ "nix-command" "flakes" ];
  nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];

  programs.virt-manager.enable = true;

  programs.steam.enable = true;
  programs.steam.extest.enable = true;
  programs.steam.protontricks.enable = true;

  # programs.steam.gamescopeSession.enable = true;
  # programs.steam.extraCompatPackages = with pkgs; [
  #   proton-ge-custom
  # ];

  # programs.gamemode.enable = true;

  # services.flatpak.enable = true;
  
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
    helix
    git
    lazygit
    fastfetch
    ripgrep

    gh
    lshw
    pciutils

    pavucontrol
    helvum
    easyeffects

    bottles
    steam-run
    wine
    wineasio
    winetricks
    # wineWowPackages.waylandFull
    mangohud

    git-lfs
    unzip
    gnumake
    cmake
    ninja
    clang
    llvmPackages_latest.llvm
    mono
    python3
    zig
    luajit
    edk2-uefi-shell

    obs-studio

    kitty
    jetbrains.clion
    zed-editor_git
    firefox
    vesktop
  ];

  # programs.nix-ld = {
  #   enable = true;
  #   libraries = with pkgs; [
  #     openssl
  #     libGL
  #     glibc
  #     glib
  #     xorg.libxcb
  #     libsForQt5.qt5.qtbase
  #   ];
  # };

  environment.sessionVariables = {
    FLAKE = "$HOME/dotfiles";
    NIXOS_OZONE_WL = "1";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CONFIG_DIR = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";

    __GL_GSYNC_ALLOWED = "0";
    __GL_VRR_ALLOWED = "0";

    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
    MOZ_ENABLE_WAYLAND = "1";
    MOZ_DISABLE_RDD_SANDBOX = "1";
  };

  # services.power-profiles-daemon.enable = true;
  services.dbus.enable = true;
  services.gvfs.enable = true;

  fonts = {
    packages = with pkgs; [
      fira
      nerd-fonts.jetbrains-mono
      noto-fonts
      noto-fonts-cjk-sans
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

  system.stateVersion = "23.11";
}
