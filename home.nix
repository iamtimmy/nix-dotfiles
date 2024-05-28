{ config, pkgs, ... }:

let 
  hyprlandStartScript = pkgs.pkgs.writeShellScriptBin "start" ''
    ${pkgs.waybar}/bin/waybar &
    ${pkgs.swww}/bin/swww init
    ${pkgs.swww}/bin/swww img ${./modules/wallpapers/one.png} &
  '';
in
{
  programs.git = {
    lfs.enable = true;
    enable = true;
    userName = "iamtimmy";
    userEmail = "58427647+iamtimmy@users.noreply.github.com";
  };

  wayland.windowManager.hyprland = {
    enable = true;

    settings = {
      exec-once = "${hyprlandStartScript}/bin/start";
    };
  };

  home.packages = [
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
    pkgs.neofetch
    
    pkgs.bottles

    pkgs.telegram-desktop
    pkgs.discord
    pkgs.freetube
    pkgs.tidal-hifi

    pkgs.ungoogled-chromium

    pkgs.vscodium-fhs
    pkgs.jetbrains.rider
    pkgs.jetbrains.clion

    pkgs.obs-studio

    pkgs.clang
    pkgs.git-lfs
    pkgs.mono
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
  home.username = "user";
  home.homeDirectory = "/home/user";
  home.stateVersion = "24.05";
}
