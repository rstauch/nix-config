# Quelle: https://github.com/carlthome/dotfiles/tree/main/modules/home-manager/vscode

{ config, pkgs, lib, self, ... }:
let
  settings-directory =
    if pkgs.stdenv.hostPlatform.isDarwin
    then "$HOME/Library/Application Support/Code/User"
    else "$HOME/.config/Code/User";

  userSettings = builtins.fromJSON (builtins.readFile "${self}/modules/vscode/settings.json");

  keybindings = builtins.fromJSON (builtins.readFile "${self}/modules/vscode/keybindings.json");

  extensions = with pkgs.vscode-extensions; [
    davidanson.vscode-markdownlint
    dbaeumer.vscode-eslint
    esbenp.prettier-vscode
    github.vscode-github-actions
    github.vscode-pull-request-github
    hashicorp.terraform
    jnoortheen.nix-ide
    mikestead.dotenv
    ms-azuretools.vscode-docker
    redhat.vscode-yaml
    stkb.rewrap
    tamasfe.even-better-toml
  ] ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
    {
      name = "git-line-blame";
      publisher = "carlthome";
      version = "0.4.0";
      sha256 = "rEhx50/OMi3glrhhC3hPhqXHEzPaTskGFvZ06CjzFkQ=";
    }
  ];
in
{
  programs.vscode = {
    inherit userSettings extensions keybindings;
    enable = true;
    mutableExtensionsDir = false;
    package = pkgs.vscode;
  };

  # Copy VS Code settings into the default location as a mutable copy.
  home.activation = {
    beforeCheckLinkTargets = {
      after = [ ];
      before = [ "checkLinkTargets" ];
      data = ''
        if [ -f "${settings-directory}/settings.json" ]; then
          rm "${settings-directory}/settings.json"
        fi
        if [ -f "${settings-directory}/keybindings.json" ]; then
          rm "${settings-directory}/keybindings.json"
        fi
      '';
    };

    afterWriteBoundary = {
      after = [ "writeBoundary" ];
      before = [ ];
      data = ''
        cat ${(pkgs.formats.json {}).generate "settings.json" userSettings} > "${settings-directory}/settings.json"
        cat ${(pkgs.formats.json {}).generate "keybindings.json" keybindings} > "${settings-directory}/keybindings.json"
      '';
    };
  };
}
