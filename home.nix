{
  config,
  pkgs,
  ...
}: {
  home.username = "moy";
  home.homeDirectory = "/home/moy";

  # link the configuration file in current directory to the specified location in home directory
  # home.file.".config/i3/wallpaper.jpg".source = ./wallpaper.jpg;

  # link all files in `./scripts` to `~/.config/i3/scripts`
  # home.file.".config/i3/scripts" = {
  #   source = ./scripts;
  #   recursive = true;   # link recursively
  #   executable = true;  # make all files executable
  # };

  # encode the file content in nix configuration file directly
  # home.file.".xxx".text = ''
  #     xxx
  # '';

  home.packages = with pkgs; [
    # archives
    zip
    unzip

    # misc
    tree

    btop # replacement of htop/nmon

    # User
    vscode
    warp-terminal
  ];

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Moises Navarro";
    userEmail = "moisalejandro@gmail.com";
  };

  programs.starship = {
    enable = true;
  };

  services.kdeconnect.enable = true;

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
