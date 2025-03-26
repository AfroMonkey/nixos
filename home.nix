{
  config,
  pkgs,
  inputs,
  ...
}: {
  home.username = "moy";
  home.homeDirectory = "/home/moy";

  home.packages = with pkgs; [
    # archives
    zip
    unzip

    # misc
    tree
    ripgrep

    btop # replacement of htop/nmon

    # User
    fish
    sqlite
    vscode
    warp-terminal
    chromium
    steam
    bitwarden-desktop
    ferdium
    vlc
    kdePackages.filelight
    obsidian
    # home-manager # wip
    pgcli
    kdePackages.yakuake
    maestral
    lan-mouse
    discord

    # development
    poetry
    uv
    ## ezaudita
    python3Packages.psycopg-c

    # Language
    aspellDicts.en
    aspellDicts.en-computers
    aspellDicts.en-science
    aspellDicts.es
    hunspellDicts.es-mx
  ];

  programs.git = {
    enable = true;
    userName = "Moises Navarro";
    userEmail = "moisalejandro@gmail.com";
  };

  programs.starship = {
    enable = true;
  };

  systemd.user.services.maestral = {
    Unit.Description = "Maestral daemon";
    Install.WantedBy = ["default.target"];
    Service = {
      ExecStart = "${pkgs.maestral}/bin/maestral start -f";
      ExecStop = "${pkgs.maestral}/bin/maestral stop";
      Restart = "on-failure";
      Nice = 10;
    };
  };

  # systemd.user.services.lan-mouse = {
  #   Unit.Description = "Lan Mouse";
  #   Unit.BindsTo = ["graphical-session.target"];
  #   Unit.After = ["graphical-session.target"];
  #   Install.WantedBy = ["graphical-session.target"];
  #   Service = {
  #     ExecStart = "${pkgs.lan-mouse}/bin/lan-mouse --daemon";
  #     Restart = "on-failure";
  #     Nice = 10;
  #   };
  # };

  home.stateVersion = "24.11";

  programs.home-manager.enable = true;
}
