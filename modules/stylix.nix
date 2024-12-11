{
  lib,
  pkgs,
  config,
  ...
}:

with lib;
let
  cfg = config.stylix-config;
in
{
  options.stylix-config = {
    enable = mkEnableOption "Configure stylix";
  };

  config = mkIf cfg.enable {
    stylix = {
      enable = true;
      # base16Scheme = {
      #   base00 = "232136";
      #   base01 = "2a273f";
      #   base02 = "393552";
      #   base03 = "6e6a86";
      #   base04 = "908caa";
      #   base05 = "e0def4";
      #   base06 = "e0def4";
      #   base07 = "56526e";
      #   base08 = "eb6f92";
      #   base09 = "f6c177";
      #   base0A = "ea9a97";
      #   base0B = "3e8fb0";
      #   base0C = "9ccfd8";
      #   base0D = "c4a7e7";
      #   base0E = "f6c177";
      #   base0F = "56526e";
      # };

      image = ../assets/wallpapers/two.jpg;

      polarity = "dark";

      # opacity.terminal = 0.8;
      cursor.package = pkgs.bibata-cursors;
      cursor.name = "Bibata-Modern-Ice";
      cursor.size = 20;

      fonts = {
        # monospace = {
        #   package = pkgs.nerdfonts.jetbrains-mono;
        #   name = "JetBrainsMono Nerd Font Mono";
        # };
        # sansSerif = {
        #   package = pkgs.montserrat;
        #   name = "Montserrat";
        # };
        # serif = {
        #   package = pkgs.montserrat;
        #   name = "Montserrat";
        # };
        sizes = {
          applications = 12;
          terminal = 15;
          desktop = 11;
          popups = 12;
        };
      };
    };
  };
}
