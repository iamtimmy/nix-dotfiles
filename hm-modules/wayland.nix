{ ... }:

{
  home.file = {
    ".config/uwsm/env".text = ''
      export QT_QPA_PLATFORMTHEME=qt5ct
      export XDG_CURRENT_TYPE=wayland
      export XDG_SESSIONS_TYPE=wayland
      export GDK_BACKEND=wayland,x11,*
      export QT_QPA_PLATFORM=wayland;xcb
      export SDL_VIDEODRIVER=wayland,x11
    '';
  };
}
