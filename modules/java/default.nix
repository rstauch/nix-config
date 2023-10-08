{ pkgs, ... }:
let
  jdkVersion = "17";

  jdk = pkgs.unstable."jdk${jdkVersion}";

  gradle = pkgs.unstable.gradle.override {
    java = jdk;
  };

  # graalvm = pkgs."graalvm${jdkVersion}-ce";

  maven = pkgs.unstable.maven.override { inherit jdk; };
in
{
  home.packages = with pkgs; [
    maven
    gradle
    # graalvm
    jdk
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
