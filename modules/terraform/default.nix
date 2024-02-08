{ pkgs, ... }:
let
  terraform = pkgs.unstable.terraform;
  # terraform-providers-kubernetes = pkgs.unstable.terraform-providers.kubernetes;
in
{
  home.packages = [
    terraform
    # terraform-providers-kubernetes
  ];
}
