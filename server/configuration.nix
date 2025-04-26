{
  config,
  pkgs,
  inputs,
  ...
}:

{
  imports = [
    ./hardware-configuration.nix
    # ./disko-config.nix
  ];

  boot.loader.grub.enable = true;
  boot.loader.grub.device = "/dev/sda";

  networking.hostName = "pve-nixos-server";
  time.timeZone = "Europe/Amsterdam";

  users.users = {
    user = {
      isNormalUser = true;
      extraGroups = [ "wheel" ];
      packages = with pkgs; [ ];
    };
  };

  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  environment.systemPackages = with pkgs; [
    helix
    nixd
    lazygit
    fastfetch
    ripgrep
    unzip

    docker-client
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

  virtualisation.docker.enable = false;
  virtualisation.podman.enable = true;
  virtualisation.podman.dockerSocket.enable = true;
  virtualisation.podman.defaultNetwork.settings.dns_enabled = true;

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
  services.openssh.settings.PasswordAuthentication = true;
  services.netbird.enable = true;

  system.stateVersion = "24.11";
}
