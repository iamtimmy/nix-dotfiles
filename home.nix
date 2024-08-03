{ config, pkgs, ... }:

{
  programs.neovim = {
    enable = true;

    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
  };

  wayland.windowManager.hyprland.systemd.variables = ["--all"];

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.vanilla-dmz;
    name = "DMZ-White";
    size = 16;
  };

  dconf = {
    enable = true;
    settings."org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  # qt = {
  #   enable = true;
  #   platformTheme = "qtct";
  #   style.name = "kvantum";
  # };

  # xdg.configFile = {
  #   "Kvantum/kvantum.kvconfig".text = ''
  #     [General]
  #     theme=GraphiteNordDark
  #   '';

  #   "Kvantum/GraphiteNord".source = "${pkgs.graphite-kde-theme}/share/Kvantum/GraphiteNord";
  # };

  home.packages = [
    pkgs.cpufetch
    pkgs.fastfetch
    
    pkgs.telegram-desktop
    pkgs.vesktop
    pkgs.discord
    pkgs.freetube
    pkgs.tidal-hifi

    pkgs.chromium
    pkgs.gpt4all

    pkgs.vscodium-fhs
    pkgs.jetbrains.rider
    pkgs.jetbrains.clion

    pkgs.obs-studio
    pkgs.easyeffects

    pkgs.git-lfs
    pkgs.unzip
    pkgs.gnumake
    pkgs.cmake
    pkgs.ninja
    pkgs.clang
    pkgs.llvmPackages_latest.llvm
    pkgs.mono
    pkgs.python3
    pkgs.zig
    pkgs.luajit

    pkgs.nil
    pkgs.zls
    pkgs.lua-language-server

    pkgs.moonlight-qt
    pkgs.localsend

    (pkgs.retroarch.override {
      cores = with pkgs.libretro; [
        mgba
        melonds
      ];
    })
    pkgs.mgba
    pkgs.melonDS
    pkgs.pegasus-frontend
    pkgs.heroic
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    # # Building this configuration will create a copy of 'dotfiles/screenrc' in
    # # the Nix store. Activating the configuration will then make '~/.screenrc' a
    # # symlink to the Nix store copy.
    # ".screenrc".source = dotfiles/screenrc;

    # # You can also set the file content immediately.
    # ".gradle/gradle.properties".text = ''
    #   org.gradle.console=verbose
    #   org.gradle.daemon.idletimeout=3600000
    # '';
  };

  # Home Manager can also manage your environment variables through
  # 'home.sessionVariables'. These will be explicitly sourced when using a
  # shell provided by Home Manager. If you don't want to manage your shell
  # through Home Manager then you have to manually source 'hm-session-vars.sh'
  # located at either
  #
  #  ~/.nix-profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  ~/.local/state/nix/profiles/profile/etc/profile.d/hm-session-vars.sh
  #
  # or
  #
  #  /etc/profiles/per-user/user/etc/profile.d/hm-session-vars.sh
  #
  home.sessionVariables = {
    EDITOR = "hx";
  };

  programs.home-manager.enable = true;
  nixpkgs.config.allowUnfree = true;
  # nix.package = pkgs.nix;
  # chaotic.nyx.overlay.onTopOf = "user-pkgs";
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "24.05";
}
