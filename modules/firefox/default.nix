{ pkgs, ... }:
let
in
{
  programs.firefox = {
    enable = true;
    package = pkgs.unstable.firefox;
    profiles.default.settings = {
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
    };
  };

  home.sessionVariables = {
    BROWSER = "firefox";
    MOZ_USE_XINPUT2 = "1";
  };
}
