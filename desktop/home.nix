{ pkgs, ... }:

{
  imports = [
    ../hm-modules/wayland.nix
    ../hm-modules/hyprland.nix
    ../hm-modules/helix.nix
    ../hm-modules/waybar.nix
    ../hm-modules/wlogout.nix
  ];

  home.packages = with pkgs; [
    telegram-desktop
    freetube
    tidal-hifi

    gpt4all

    qbittorrent

    localsend

    aichat
    vesktop

    jetbrains.idea-community-bin
    jetbrains.clion
    zed-editor_git

    steam-run

    git-lfs
    unzip
    gnumake
    cmake
    ninja
    clang
    mono
    python3
    zig
    luajit
    edk2-uefi-shell
    llvmPackages_latest.llvm
    jdk11
  ];

  programs = {
    home-manager.enable = true;

    btop = {
      enable = true;
      settings = {
        vim_keys = true;
      };
    };

    starship = {
      enable = true;
      package = pkgs.starship;
    };

    bash = {
      enable = true;
      enableCompletion = true;
    };
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
  # home.sessionVariables = {
  #   EDITOR = "hx";
  # };

  nixpkgs.config.allowUnfree = true;

  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "24.05";
}
