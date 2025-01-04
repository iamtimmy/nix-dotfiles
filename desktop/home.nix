{ pkgs, ... }:

let
  grayjay = pkgs.callPackage ../pkgs/grayjay.nix { };
in
{
  imports = [
    ../hm-modules/wayland.nix
    ../hm-modules/hyprland.nix
    ../hm-modules/helix.nix
    ../hm-modules/waybar.nix
    ../hm-modules/wlogout.nix

    ../hm-modules/development.nix
  ];

  home.packages = with pkgs; [
    vesktop
    telegram-desktop
    grayjay
    freetube
    tidal-hifi

    qbittorrent
    localsend

    # aichat

    jetbrains.idea-community-bin
    jetbrains.clion
    # zed-editor_git

    cointop

    ungoogled-chromium
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

  fonts.fontconfig.enable = true;

  nixpkgs.config.allowUnfree = true;

  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "24.05";
}
