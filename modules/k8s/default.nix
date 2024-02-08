{ pkgs, ... }:
let
  helm = pkgs.unstable.kubernetes-helm;
  minikube = pkgs.unstable.minikube;
  k9s = pkgs.unstable.k9s;
  kubectl = pkgs.unstable.kubectl;
  kind = pkgs.unstable.kind;
in
{
  home.packages = [
    helm
    minikube
    k9s
    kubectl
    kind
  ];
}
