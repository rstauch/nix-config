{ pkgs, ... }:
let
  dbeaver = pkgs.unstable.dbeaver;
in
{
  home.packages = [
    dbeaver
  ];
}
