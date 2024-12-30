{ pkgs, lib, ... }:

{
  home.file = {
    ".config/uwsm/env-hyprland".text = ''
      export XDG_CURRENT_DESKTOP=Hyprland
      export XDG_SESSION_DESKTOP=Hyprland
    '';
  };

  stylix.targets.hyprland.enable = false;

  wayland.windowManager.hyprland = {
    enable = true;
    # xwayland.enable = true;
    # withUWSM = true;

    extraConfig =
      let
        # AUTOSTART
        super = "SUPER";

        terminalCommand = "uwsm app -- ${pkgs.ghostty}/bin/ghostty";
        fileManagerCommand = "uwsm app -- ${pkgs.xfce.thunar}/bin/thunar";
        menuCommand = "uwsm app -- ${pkgs.rofi}/bin/rofi -show drun -show-colors";
        logoutCommand = "${pkgs.wlogout}/bin/wlogout";

      in
      lib.concatStrings [
        ''
          ################
          ### MONITORS ###
          ################

          # See https://wiki.hyprland.org/Configuring/Monitors/
          monitor = ,highres@highrr,auto,1

          #################
          ### AUTOSTART ###
          #################

          # Autostart necessary processes (like notifications daemons, status bars, etc.)
          # Or execute your favorite apps at launch like this:

          #############################
          ### ENVIRONMENT VARIABLES ###
          #############################

          # See https://wiki.hyprland.org/Configuring/Environment-variables/

          # MOVED TO /hm-modules/wayland.nix and /hm-modules/hyprland.nix

          xwayland {
              force_zero_scaling = true
          }

          #####################
          ### LOOK AND FEEL ###
          #####################

          # Refer to https://wiki.hyprland.org/Configuring/Variables/

          # https://wiki.hyprland.org/Configuring/Variables/#general
          general { 
              gaps_in = 0
              gaps_out = 2

              border_size = 1

              # https://wiki.hyprland.org/Configuring/Variables/#variable-types for info about colors
              col.active_border = rgba(FFFFFFFF)
              col.inactive_border = rgba(FF000000)

              # Set to true enable resizing windows by clicking and dragging on borders and gaps
              resize_on_border = false 

              # Please see https://wiki.hyprland.org/Configuring/Tearing/ before you turn this on
              allow_tearing = false

              layout = dwindle
          }

          # https://wiki.hyprland.org/Configuring/Variables/#decoration
          decoration {
              rounding = 0

              # Change transparency of focused and unfocused windows
              active_opacity = 1.0
              inactive_opacity = 1.0

              # drop_shadow = true
              # shadow_range = 4
              # shadow_render_power = 3
              # col.shadow = rgba(1a1a1aee)

              # https://wiki.hyprland.org/Configuring/Variables/#blur
              blur {
                  enabled = false
                  size = 3
                  passes = 1

                  vibrancy = 0.1696
              }
          }

          # https://wiki.hyprland.org/Configuring/Variables/#animations
          animations {
              enabled = true

              # Default animations, see https://wiki.hyprland.org/Configuring/Animations/ for more

              bezier = myBezier, 0.2, 0.9, 0.1, 1.05

              animation = windows, 1, 7, myBezier
              animation = windowsOut, 1, 7, default, popin 80%
              animation = border, 1, 10, default
              animation = borderangle, 1, 8, default
              animation = fade, 1, 7, default
              animation = workspaces, 1, 6, default
          }

          # See https://wiki.hyprland.org/Configuring/Dwindle-Layout/ for more
          dwindle {
              pseudotile = true # Master switch for pseudotiling. Enabling is bound to mainMod + P in the keybinds section below
              preserve_split = true # You probably want this
          }

          # See https://wiki.hyprland.org/Configuring/Master-Layout/ for more
          master {
              # TODO: no longer exists; find out why
              # new_is_master = true
          }

          # https://wiki.hyprland.org/Configuring/Variables/#misc
          misc { 
              force_default_wallpaper = -1 # Set to 0 or 1 to disable the anime mascot wallpapers
              disable_hyprland_logo = true # If true disables the random hyprland logo / anime girl background. :(
          }


          #############
          ### INPUT ###
          #############

          # https://wiki.hyprland.org/Configuring/Variables/#input
          input {
              kb_layout = us

              follow_mouse = 1

              sensitivity = 0 # -1.0 - 1.0, 0 means no modification.
              accel_profile = flat
              force_no_accel = 1

              touchpad {
                  natural_scroll = false
              }
          }

          # https://wiki.hyprland.org/Configuring/Variables/#gestures
          gestures {
              workspace_swipe = false
          }

          ####################
          ### KEYBINDINGSS ###
          ####################

          # See https://wiki.hyprland.org/Configuring/Keywords/

          # Example binds, see https://wiki.hyprland.org/Configuring/Binds/ for more
          bind = ${super}, Q, exec, ${terminalCommand}
          bind = ${super}, C, killactive,
          bind = ${super}, M, exec, uwsm stop
          bind = ${super}, E, exec, ${fileManagerCommand}
          bind = ${super}, R, exec, ${menuCommand}
          bind = ${super}, V, togglefloating,
          bind = ${super}, P, pseudo, # dwindle
          bind = ${super}, J, togglesplit, # dwindle
          bind = ${super}, L, exec, ${logoutCommand}

          # Move focus with {super} + arrow keys
          bind = ${super}, left, movefocus, l
          bind = ${super}, right, movefocus, r
          bind = ${super}, up, movefocus, u
          bind = ${super}, down, movefocus, d

          # Switch workspaces with {super} + [0-9]
          bind = ${super}, 1, workspace, 1
          bind = ${super}, 2, workspace, 2
          bind = ${super}, 3, workspace, 3
          bind = ${super}, 4, workspace, 4
          bind = ${super}, 5, workspace, 5
          bind = ${super}, 6, workspace, 6
          bind = ${super}, 7, workspace, 7
          bind = ${super}, 8, workspace, 8
          bind = ${super}, 9, workspace, 9
          bind = ${super}, 0, workspace, 10

          # Move active window to a workspace with {super} + SHIFT + [0-9]
          bind = ${super} SHIFT, 1, movetoworkspace, 1
          bind = ${super} SHIFT, 2, movetoworkspace, 2
          bind = ${super} SHIFT, 3, movetoworkspace, 3
          bind = ${super} SHIFT, 4, movetoworkspace, 4
          bind = ${super} SHIFT, 5, movetoworkspace, 5
          bind = ${super} SHIFT, 6, movetoworkspace, 6
          bind = ${super} SHIFT, 7, movetoworkspace, 7
          bind = ${super} SHIFT, 8, movetoworkspace, 8
          bind = ${super} SHIFT, 9, movetoworkspace, 9
          bind = ${super} SHIFT, 0, movetoworkspace, 10

          # Example special workspace (scratchpad)
          bind = ${super}, S, togglespecialworkspace, magic
          bind = ${super} SHIFT, S, movetoworkspace, special:magic

          # Scroll through existing workspaces with {super} + scroll
          bind = ${super}, mouse_down, workspace, e+1
          bind = ${super}, mouse_up, workspace, e-1

          # Move/resize windows with {super} + LMB/RMB and dragging
          bindm = ${super}, mouse:272, movewindow
          bindm = ${super}, mouse:273, resizewindow

          windowrulev2 = suppressevent maximize, class:.* # You'll probably like this.

          bind = , PRINT, exec, uwsm app -- hyprshot -m window --clipboard-only # Screenshot a window
          bind = ${super}, PRINT, exec, uwsm app -- hyprshot -m output --clipboard-only # Screenshot a monitor
          bind = ${super} SHIFT, PRINT, exec, uwsm app -- hyprshot -m region --clipboard-only # Screenshot a region
        ''
      ];
  };

  systemd.user.services.hypr-lxqt-policykit-unit = {
    Unit.Description = "systemd unit for lxqt policy kit";
    Unit.After = [ "graphical-session.target" ];

    Install.WantedBy = [ "xdg-desktop-autostart.target" ];

    Service = {
      ExecStart = "${pkgs.lxqt.lxqt-policykit}/bin/lxqt-policykit-agent";
      ExecReload = "kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      Slice = [ "background-graphical.slice" ];
    };
  };

  systemd.user.services.hypr-waybar-unit = {
    Unit.Description = "systemd unit for waybar";
    Unit.After = [ "graphical-session.target" ];

    Install.WantedBy = [ "xdg-desktop-autostart.target" ];

    Service = {
      ExecStart = "${pkgs.waybar}/bin/waybar";
      ExecReload = "kill -SIGUSR2 $MAINPID";
      Restart = "on-failure";
      Slice = [ "background-graphical.slice" ];
    };
  };

  systemd.user.services.hypr-swww-daemon-unit = {
    # Unit.Description = "systemd unit for swww";
    Unit.Description = "systemd unit for swww-daemon";
    Unit.After = [ "graphical-session.target" ];

    Install.WantedBy = [ "xdg-desktop-autostart.target" ];

    Service = {
      ExecStart = "${pkgs.swww}/bin/swww-daemon";
      # ExecStart = "${pkgs.writeShellScript "hypr-swww-unit-script" ''
      #   #!${pkgs.bash}/bin/bash
      #   ${pkgs.swww}/bin/swww-daemon &;
      #   sleep 1
      #   ${pkgs.swww}/bin/swww img ~/dotfiles/assets/wallpapers/one.png
      # ''}";
      # ExecReload = "kill -SIGUSR2 $MAINPID; pkill -15 swww-daemon}]";
      ExecReload = "kill -SIGUSR2 $MAINPID}]";
      Restart = "on-failure";
      Slice = [ "background-graphical.slice" ];
    };
  };

  services = {
    hypridle = {
      enable = true;
      settings = {
        general = {
          after_sleep_cmd = "hyprctl dispatch dpms on";
          ignore_dbus_inhibit = false;
          lock_cmd = "hyprlock";
        };
        listener = [
          {
            timeout = 900;
            on-timeout = "hyprlock";
          }
          {
            timeout = 1200;
            on-timeout = "hyprctl dispatch dpms off";
            on-resume = "hyprctl dispatch dpms on";
          }
        ];
      };
    };
  };

  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        grace = 10;
        hide_cursor = true;
        no_fade_in = false;
      };

      # input-field = [
      #   {
      #     size = "200, 50";
      #     position = "0, -80";
      #     monitor = "";
      #     dots_center = true;
      #     fade_on_empty = false;
      #     font_color = "rgb(CFE6F4)";
      #     inner_color = "rgb(657DC2)";
      #     outer_color = "rgb(0D0E15)";
      #     outline_thickness = 5;
      #     placeholder_text = "Password...";
      #     shadow_passes = 2;
      #   }
      # ];
    };
  };
}
