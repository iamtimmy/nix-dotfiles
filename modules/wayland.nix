{
  lib,
  pkgs,
  config,
  ...
}:
with lib;
let
  cfg = config.wayland-config;
in
{
  options.wayland-config = {
    enable = mkEnableOption "Configure wayland stuff";
  };

  config = mkIf cfg.enable {
    programs.uwsm.enable = true;

    environment.systemPackages = with pkgs; [
      wl-clipboard
      wl-clip-persist
      xwaylandvideobridge
      libnotify
    ];
  };
}

