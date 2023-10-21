{ pkgs ? import <nixpkgs> { } }:
let
  jdk = pkgs.jdk17;

  # point gradle to the jdk
  gradle = pkgs.gradle.override {
    java = jdk;
  };

  maven = pkgs.maven.override { inherit jdk; };
in
pkgs.mkShell {
  buildInputs = [
    gradle
    maven
    jdk
  ];
}

# java --version
# mvn --version
# gradle --version
# env | grep -i java
