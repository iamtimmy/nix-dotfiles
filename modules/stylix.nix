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
      base16Scheme = {
        base00 = "282828";
        base01 = "3c3836";
        base02 = "504945";
        base03 = "665c54";
        base04 = "bdae93";
        base05 = "d5c4a1";
        base06 = "ebdbb2";
        base07 = "fbf1c7";
        base08 = "fb4934";
        base09 = "fe8019";
        base0A = "fabd2f";
        base0B = "b8bb26";
        base0C = "8ec07c";
        base0D = "83a598";
        base0E = "d3869b";
        base0F = "d65d0e";
      };

      # base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-dark-medium.yaml";

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
