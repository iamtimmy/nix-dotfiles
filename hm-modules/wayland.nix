{ ... }:

{
  home.file = {
    ".config/uwsm/env".text = ''
      export XDG_CURRENT_TYPE=wayland
      export XDG_SESSIONS_TYPE=wayland
      export GDK_BACKEND=wayland,x11,*
      export SDL_VIDEODRIVER=wayland,x11
      export QT_QPA_PLATFORM=wayland;xcb
      export CLUTTER_BACKEND=wayland
      export QT_QPA_PLATFORMTHEME=qt5ct
    '';

    ".config/electron-flags.conf".text = ''
      --ozone-platform-hint=auto
      --enable-features=WaylandWindowDecorations
    '';
  };
}
