{  pkgs, ... }:

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
    remmina

    vlc
    vesktop
    simplex-chat-desktop
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

    eza = {
      enable = true;
      enableNushellIntegration = true;
      enableFishIntegration = true;
      enableBashIntegration = true;
    };

    carapace = {
      enable = true;
      enableNushellIntegration = true;
      enableBashIntegration = true;
      enableFishIntegration = true;
    };

    direnv.enable = true;

    fish = {
      enable = true;
      shellInit = "set fish_greeting";
    };
    
    nushell = {
      enable = true;
      extraConfig = ''
       let carapace_completer = {|spans|
       carapace $spans.0 nushell $spans | from json
       }
       $env.config = {
        show_banner: false,
        completions: {
        case_sensitive: false # case-sensitive completions
        quick: true    # set to false to prevent auto-selecting completions
        partial: true    # set to false to prevent partial filling of the prompt
        algorithm: "fuzzy"    # prefix or fuzzy
        external: {
        # set to false to prevent nushell looking into $env.PATH to find more suggestions
            enable: true 
        # set to lower can improve completion performance at the cost of omitting some options
            max_results: 100 
            completer: $carapace_completer # check 'carapace_completer' 
          }
        }
       } 
       $env.PATH = ($env.PATH | 
       split row (char esep) |
       prepend /home/user/.apps |
       append /usr/bin/env
       )
       '';
    };

    zellij.enable = true;
  };

  fonts.fontconfig.enable = true;

  home.username = "user";
  home.homeDirectory = "/home/user";

  home.stateVersion = "24.05";
}
