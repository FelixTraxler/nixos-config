{ config, pkgs, ... }:

{
  home.username = "felix";
  home.homeDirectory = "/home/felix";

  home.stateVersion = "25.11";

  programs.home-manager.enable = true;

  home.packages = [
    pkgs.htop
    pkgs.fortune
  ];
}
