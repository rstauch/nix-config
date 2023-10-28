{ pkgs, ... }:
let

in
{
  # bundle plugin, since github copilot agent does not work on nixos, taken from: https://github.com/NixOS/nixpkgs/pull/223593
  # base plugin versions: https://github.com/NixOS/nixpkgs/blob/nixpkgs-unstable/pkgs/applications/editors/jetbrains/plugins/plugins.json
  # base intellij version: https://github.com/NixOS/nixpkgs/blob/nixos-unstable/pkgs/applications/editors/jetbrains/default.nix
  home.packages = [
    (pkgs.unstable.jetbrains.plugins.addPlugins pkgs.unstable.jetbrains.idea-ultimate [ "github-copilot" "nixidea" ])
  ];
}
