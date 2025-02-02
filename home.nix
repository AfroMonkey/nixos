{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  home.username = "moy";
  home.homeDirectory = "/home/moy";

  home.packages = with pkgs; [
    # archives
    zip
    unzip

    # misc
    tree

    btop # replacement of htop/nmon

    # User
    fish
    vscode
    warp-terminal
    chromium
    steam
    bitwarden-desktop
  ];

  # programs.steam = {
  #   enable = true;
  #   remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
  #   dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
  #   localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
  #   platformOptimizations.enable = true;
  # };

  programs.git = {
    enable = true;
    userName = "Moises Navarro";
    userEmail = "moisalejandro@gmail.com";
  };

  programs.starship = {
    enable = true;
  };

  programs.fish = {
    enable = true;
  };
  programs.plasma = {
    enable = true;

    hotkeys.commands."launch-konsole" = {
      name = "Launch Konsole";
      key = "Control+Alt+K";
      command = "konsole";
    };
    hotkeys.commands."launch-warp" = {
      name = "Launch warp";
      key = "Control+Alt+T";
      command = "warp";
    };

    panels = [
      {
        location = "bottom";
        widgets = [
          {
            name = "org.kde.plasma.kickoff";
            config = {
              General = {
                icon = "nix-snowflake-white";
              };
            };
          }
          {
            iconTasks = {
              launchers = [
                "applications:org.kde.dolphin.desktop"
                "applications:app.zen_browser.zen.desktop"
                "applications:code.desktop"
                "applications:warp.desktop"
              ];
            };
          }
          {
            digitalClock = {
              calendar.firstDayOfWeek = "sunday";
              time.format = "24h";
            };
          }
          {
            systemTray.items = {
            };
          }
        ];
      }
    ];
  };

  # This value determines the home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update home Manager without changing this value. See
  # the home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "24.11";

  # Let home Manager install and manage itself.
  programs.home-manager.enable = true;
}
