let
  unstable = import (fetchTarball "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz") { };
  graalvm = unstable.graalvm-ce;

  gradle = unstable.gradle.override {
    java = graalvm;
  };

  maven = unstable.maven.override { jdk = graalvm; };
in
{ nixpkgs ? import <nixpkgs> { } }:
with nixpkgs; mkShell {
  buildInputs = [ gradle maven graalvm ];
  shellHook = ''
    export GRAALVM_HOME="${graalvm}"
  '';
}

# java --version
# mvn --version
# gradle --version
# env | grep -i java
