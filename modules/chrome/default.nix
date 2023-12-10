{ pkgs, ... }:
let
in
{
  programs.google-chrome = {
    enable = true;
    package = pkgs.unstable.google-chrome;
  };
}
