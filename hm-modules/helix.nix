{ pkgs, ... }:

{
  home.packages = with pkgs; [
    nixd
    nil
    nixpkgs-fmt
    nixfmt-rfc-style
    alejandra

    zls
    lua-language-server
  ];

  home.file = {
    ".config/helix/config.toml".text = ''
      theme = "onedark"

      [editor]
      line-number = "relative"
      mouse = false

      [editor.cursor-shape]
      insert = "bar"
      normal = "block"
      select = "underline"

      [editor.file-picker]
      hidden = false
    '';
  };

  home.sessionVariables = {
    EDITOR = "hx";
  };
}
