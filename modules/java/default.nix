{ pkgs, ... }:
let
  jdkVersion = "17";

  jdk = pkgs.unstable."jdk${jdkVersion}";

  gradle = pkgs.unstable.gradle.override {
    java = jdk;
  };

  # clashes with jdk17 ?
  # graalvm = pkgs."graalvm${jdkVersion}-ce";

  maven = pkgs.unstable.maven.override { inherit jdk; };
in
{
  home.packages = [
    maven
    gradle
    jdk
    # graalvm
  ];

  home.sessionVariables = {
    JAVA_HOME = "${jdk}/lib/openjdk";
    # GRAALVM_HOME = "${graalvm}";
  };

}

# check with:
# java --version # contains GRAALVM info
# mvn --version
# gradle --version
# env | grep -i java
# env | grep -i graal
