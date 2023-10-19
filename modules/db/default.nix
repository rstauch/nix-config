{ pkgs, ... }:
let
  mysql-workbench = pkgs.unstable.mysql-workbench;
  dbeaver = pkgs.unstable.dbeaver;
in
{
  home.packages = [
    mysql-workbench # not available as mac pkg?
    dbeaver
  ];
}
