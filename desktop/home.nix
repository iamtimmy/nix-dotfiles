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

    cointop
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

  nixpkgs.config.allowUnfree = true;

  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "24.05";
}
