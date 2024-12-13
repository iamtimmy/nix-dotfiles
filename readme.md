My personal NixOS system configurations and dotfiles

After installation login from the tty and run:
```sh
uwsm start default
```

## Features
- desktop host
  - [CachyOS](https://cachyos.org/) kernel from [chaotic](https://www.nyx.chaotic.cx/)
  - [uwsm](https://github.com/Vladimir-csp/uwsm) integration
  - [Hyprland](https://hyprland.org/) window manager 
    - rofi
    - waybar
    - policy kit
    - screenshots
    - wlogout and hypridle
    - screen sharing features work
      - 10 bith color depth not working and hdr untested
    - obs virtual camera support
  - [stylix](https://stylix.danth.me/) support
  - [ollama](https://ollama.com/) configuration for a 7900 XT
  - Thrustmaster T300RS GT driver and configuration software in `modules/wheelsupport.nix`
    - had to copy and fix overwheel and hid-tmff2 derivations in `pkgs/`
    - Thrustmaster TH8A works out of the box
  - A few more bleeding edge packages like the zed editor and proton-ge from [chaotic](https://www.nyx.chaotic.cx/)
- server host
  - wip automated installation

## TODO List
- disable hardware specific options by default
  - for now, carefully `read modules/` and `hm-modules/` before copying verbatim
- support more hardware configurations
- add more applications to dotfiles
- strip the path of packages that don't need to be there
  - some should be moved to home-manager
  - some should be directly referenced from dotfile generation
- document how I got headtracking to work in simulation games
  - including proton support
- add more features like other window managers and a desktop environment
- support automated installations from minimal iso boot

## Resources
- [for theming images and dotfiles](https://gitlab.com/Zaney/zaneyos)
