{pkgs, ...}: {
  home = {
    username = "felix";
    homeDirectory = "/home/felix";

    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.htop
    pkgs.fortune
  ];
}
