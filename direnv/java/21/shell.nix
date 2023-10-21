let
  unstable = import (fetchTarball "https://nixos.org/channels/nixos-unstable/nixexprs.tar.xz") { };
  jdk = unstable.jdk21;

  gradle = unstable.gradle.override {
    java = jdk;
  };

  maven = unstable.maven.override { inherit jdk; };
in
{ nixpkgs ? import <nixpkgs> { } }:
with nixpkgs; mkShell {
  buildInputs = [ gradle maven jdk ];
}

# java --version
# mvn --version
# gradle --version
# env | grep -i java
