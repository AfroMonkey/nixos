{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;
  services.fwupd.enable = true;
  # boot.initrd.luks.devices."luks-880e3a13-72ff-4c4c-b9d5-4986891c4b25".device = "/dev/disk/by-uuid/880e3a13-72ff-4c4c-b9d5-4986891c4b25";
  networking.hostName = "afroframe";

  networking.networkmanager.enable = true;

  time.timeZone = "America/Mexico_City";

  i18n.defaultLocale = "en_US.UTF-8";

  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.printing.enable = true;

  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
  };

  users.users.moy = {
    isNormalUser = true;
    initialPassword = "1";
    description = "moy";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  services.xserver.displayManager.autoLogin.enable = true;
  services.xserver.displayManager.autoLogin.user = "moy";
  services.systembus-notify.enable = true;

  programs.firefox.enable = true;

  nixpkgs.config.allowUnfree = true;

  services.flatpak.enable = true; # WIP for zen-browser

  environment.systemPackages = with pkgs; [
    vim
    git
    alejandra

    kdePackages.kdeconnect-kde

    fprintd
  ];

  services.fprintd.enable = true;

  # KDE Connect
  networking.firewall = rec {
    allowedTCPPortRanges = [
      {
        from = 1714;
        to = 1764;
      }
    ];
    allowedUDPPortRanges = allowedTCPPortRanges;
  };

  networking.extraHosts = ''
    192.168.0.158 afropc
  '';

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
