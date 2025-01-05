{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.hyprland-config;
in
{
  options.hyprland-config = {
    enable = mkEnableOption "Configure nixos system to support and early load amd GPU Drivers";
  };

  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland.enable = true;
      withUWSM = true;
    };

    programs.uwsm.waylandCompositors.hyprland = {
      prettyName = "Hyprland";
      comment = "Hyprland compositor managed by UWSM";
      binPath = "/run/current-system/sw/bin/Hyprland";
    };

    environment.systemPackages = with pkgs; [
      hyprland-qtutils
      ghostty # default terminal

      waybar

      mako
      satty

      swww # wallpaper tool
      hyprshot # screenshot tool

      cliphist # clipboard history tool TODO: configure

      xorg.xlsclients # TODO: misplaced; unrelated to hyprland specifically, maybe used for xwayland support
    ];
  };
}
