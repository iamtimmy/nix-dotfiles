{ config, pkgs, inputs, ... }:

{
  imports =
    [
      ./hardware-configuration.nix
    ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "server";
  time.timeZone = "Europe/Amsterdam";

  users.users = {
    user = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [];
      openssh.authorizedKeys.keys = [
        "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8oe45z5nAxfwouyxTm1HAUGkXBVeb/CS4HEwel1kdcEqNlOy1RC5kJu41u7hzT+pBUE7B7/f94k80jp6Bl0+iGT/7xRqlkdABAKxVY/A/vhXxjZhOzUOMKhMswHOoNOGINvq6v43RXAwmbqkd8Zb2xp27HB3XEwFiPHrUhh9DYN+i0RpJI9lzvQE0MP3W9HMmClLdB6JG8x1lQOpgIQ2aYGX9B/qKqH+j7UNdyJHlUxF5xuIVoOjI7VU0oa7UzpytdZbkQYS3taj1da5rqL87RtG/5FQ9vEFMFWUJ3EW1T8lFTfndVvjRgOSnDUS54pa2j24Hm8hAsU3qg/frns4qReYjtb2PyYdH73S8lzmhEGdXNOGmoyotr1+8UcBj4yyWOVbx30U+npEhcLr700nuN3jgH/3UXPy69UujcJ/wLAy+9jYU1UO3hP79kKszwP1SQxOTvQtMO9hDVlmbewxu9YX3S25v4a7nLgK3J/mDiN1ma3n/OY9e8SQOJBiMiz8= user@desktop"
      ];
    };

    root.openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQC8oe45z5nAxfwouyxTm1HAUGkXBVeb/CS4HEwel1kdcEqNlOy1RC5kJu41u7hzT+pBUE7B7/f94k80jp6Bl0+iGT/7xRqlkdABAKxVY/A/vhXxjZhOzUOMKhMswHOoNOGINvq6v43RXAwmbqkd8Zb2xp27HB3XEwFiPHrUhh9DYN+i0RpJI9lzvQE0MP3W9HMmClLdB6JG8x1lQOpgIQ2aYGX9B/qKqH+j7UNdyJHlUxF5xuIVoOjI7VU0oa7UzpytdZbkQYS3taj1da5rqL87RtG/5FQ9vEFMFWUJ3EW1T8lFTfndVvjRgOSnDUS54pa2j24Hm8hAsU3qg/frns4qReYjtb2PyYdH73S8lzmhEGdXNOGmoyotr1+8UcBj4yyWOVbx30U+npEhcLr700nuN3jgH/3UXPy69UujcJ/wLAy+9jYU1UO3hP79kKszwP1SQxOTvQtMO9hDVlmbewxu9YX3S25v4a7nLgK3J/mDiN1ma3n/OY9e8SQOJBiMiz8= user@desktop"
    ];
  };

  # nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    helix
    nixd
    lazygit
    fastfetch
    ripgrep
    unzip
  ];

  programs.nh = {
    enable = true;
    clean.enable = true;
    clean.extraArgs = "--keep-since 4d --keep 10";
  };

  programs.git = {
    enable = true;
    lfs.enable = true;
  };

  programs.firejail.enable = true;

  environment.sessionVariables = {
    FLAKE = "$HOME/dotfiles";

    XDG_CACHE_HOME = "$HOME/.cache";
    XDG_CONFIG_HOME = "$HOME/.config";
    XDG_CONFIG_DIR = "$HOME/.config";
    XDG_DATA_HOME = "$HOME/.local/share";
    XDG_STATE_HOME = "$HOME/.local/state";
  };

  # Enable the OpenSSH daemon.
  services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  system.stateVersion = "24.05";
}
