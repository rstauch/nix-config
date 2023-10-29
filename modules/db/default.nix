{ pkgs, ... }:
let
  dbeaver = pkgs.unstable.dbeaver;
  clickhouse = pkgs.unstable.clickhouse;
in
{
  home.packages = [
    dbeaver
    clickhouse
  ];
}
