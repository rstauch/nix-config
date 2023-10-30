{ pkgs, ... }:
let
  jdk17 = pkgs.unstable."jdk17";

  # install jdk21 in order to provide it to IntelliJ (if required)
  jdk21 = pkgs.unstable."jdk21".overrideAttrs (oldAttrs: {
    meta.priority = 10;
  });

  gradle = pkgs.unstable.gradle.override {
    java = jdk17;
  };

  maven = pkgs.unstable.maven.override { jdk = jdk17; };
in
{
  home.packages = [
    maven
    gradle
    jdk17
    jdk21
  ];

  home.sessionVariables = {
    JAVA_HOME = "${jdk17}/lib/openjdk";
  };

  home.file."jdks/jdk17".source = jdk17;
  home.file."jdks/jdk21".source = jdk21;
}

# check with:
# java --version # should return java17
# mvn --version # should return java17
# gradle --version # should return java17
# env | grep -i java  # should return java17
