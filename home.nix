{ config, pkgs, ... }:

{
  wayland.windowManager.hyprland.systemd.variables = ["--all"];

  home.packages = [
    pkgs.telegram-desktop
    pkgs.freetube
    pkgs.tidal-hifi

    pkgs.gpt4all

    pkgs.nil
    pkgs.zls
    pkgs.lua-language-server

    pkgs.localsend

    pkgs.mgba
    pkgs.melonDS
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
