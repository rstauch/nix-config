{ pkgs, ... }:
let
in {
  programs.broot = {
    enable = true;
    package = pkgs.unstable.broot;

    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
  };

  home.file.".config/broot/verbs.hjson".source = ./verbs.hjson;
}
