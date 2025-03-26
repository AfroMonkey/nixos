{
  config,
  lib,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];
  boot.initrd.systemd.enable = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  nix.settings.experimental-features = ["nix-command" "flakes"];

  boot.kernelPackages = pkgs.linuxPackages_zen;

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
  services.flatpak.enable = true;

  services.flatpak.packages = [
    "app.zen_browser.zen"
  ];
  services.flatpak.update.onActivation = true;

  services.printing.enable = true;

  # services.pulseaudio.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    # pulse.enable = true;
  };
  programs.fish.enable = true;
  documentation.man.generateCaches = false;

  users.users.moy = {
    isNormalUser = true;
    initialPassword = "1";
    description = "moy";
    extraGroups = ["networkmanager" "wheel"];
    packages = with pkgs; [
      kdePackages.kate
    ];
    shell = pkgs.fish;
  };

  #services.xserver.displayManager.autoLogin.enable = true;
  #services.xserver.displayManager.autoLogin.user = "moy";
  services.systembus-notify.enable = true;

  hardware.bluetooth.enable = true; # enables support for Bluetooth
  hardware.bluetooth.powerOnBoot = true; # powers up the default Bluetooth controller on boot

  hardware.bluetooth.settings = {
    General = {
      Enable = "Source,Sink,Media,Socket";
      Experimental = true;
    };
  };

  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = with pkgs; [
    vim
    git
    alejandra
    nixd

    kdePackages.kdeconnect-kde

    fprintd

    tpm2-tss
    # sudo systemd-cryptenroll --tpm2-device=auto --tpm2-pcrs=0 /dev/nvme0n1p2
    btrfs-assistant
    snapper
    snapper-gui
  ];
  programs.dconf.enable = true;
  services.snapper.configs = {
    home = {
      SUBVOLUME = "/home";
      ALLOW_USERS = ["moy"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_HOURLY = 5;
      TIMELINE_LIMIT_DAILY = 7;
      TIMELINE_LIMIT_WEEKLY = 3;
      TIMELINE_LIMIT_MONTHLY = 1;
      TIMELINE_LIMIT_YEARLY = 1;
    };
    log = {
      SUBVOLUME = "/var/log";
      ALLOW_USERS = ["moy"];
      TIMELINE_CREATE = true;
      TIMELINE_CLEANUP = true;
      TIMELINE_LIMIT_DAILY = 7;
    };
  };
  services.snapper.persistentTimer = true;
  services.btrfs.autoScrub.enable = true;

  services.fprintd.enable = true;

  services.postgresql = {
    enable = true;
  };

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

  # boot = {
  #   kernelParams = [
  #     "resume_offset=533760"
  #   ];
  #   resumeDevice = "/dev/disk/by-label/nixos";
  # };

  system.autoUpgrade = {
    enable = true;
    flake = "/home/moy/nixos";
    flags = [
      "--update-input"
      "nixpkgs"
      "--no-write-lock-file"
      "-L" # print build logs
    ];
    dates = "02:00";
    randomizedDelaySec = "45min";
  };

  nix.gc = {
    automatic = true;
    randomizedDelaySec = "14m";
    options = "--delete-older-than 10d";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "24.11"; # Did you read the comment?
}
