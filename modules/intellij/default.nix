{ pkgs, ... }:
let
  intellij = pkgs.unstable.jetbrains.idea-ultimate;
in
{
  home.packages = [
    intellij
  ];
}
