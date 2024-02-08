{ pkgs, ... }:
let
  terraform = pkgs.unstable.terraform;
  tflint = pkgs.unstable.tflint;
in
{
  home.packages = [
    terraform
    tflint
  ];
}
