{ config
, pkgs
, username
, nix-index-database
, ...
}:
let
  vscode = import ./modules/vscode;
  firefox = import ./modules/firefox;
  java = import ./modules/java;
  broot = import ./modules/broot;
  zsh = import ./modules/zsh;

  unstable-packages = with pkgs.unstable; [
    # FIXME: select your core binaries that you always want on the bleeding-edge
    bat
    bottom
    coreutils
    curl
    dos2unix
    du-dust
    fd
    findutils
    fx # terminal json viewer
    git
    git-crypt
    gron # Make JSON greppable, https://github.com/tomnomnom/gron
    htop
    jq
    just
    killall
    nerdfonts
    nodejs_18
    openssl
    procs
    q-text-as-data # Run SQL directly on CSV or TSV files, https://github.com/harelba/q
    ripgrep
    tldr
    tree
    unzip
    wget
    xdg-utils
    xz
    yarn
    zip

    # postman # https://github.com/NixOS/nixpkgs/issues/259147
    _1password-gui
  ];

  stable-packages = with pkgs; [
    # FIXME: customize these stable packages to your liking for the languages that you use
    # language servers
    nodePackages.typescript-language-server
    pkgs.nodePackages.vscode-langservers-extracted # html, css, json, eslint
    nodePackages.yaml-language-server
    sumneko-lua-language-server
    nil # nix

    # formatters and linters
    alejandra # nix
    deadnix # nix
    golangci-lint
    lua52Packages.luacheck
    nodePackages.prettier
    shellcheck
    shfmt
    fmt
    statix # nix
    nixfmt
    nixpkgs-fmt
    nixpkgs-review
    sqlfluff
    tflint
  ];
in
{
  imports = [
    nix-index-database.hmModules.nix-index
    vscode
    firefox
    java
    broot
    zsh
  ];

  home.stateVersion = "22.11";

  home = {
    username = "${username}";
    homeDirectory = "/home/${username}";

    sessionVariables.SHELL = "/etc/profiles/per-user/${username}/bin/zsh";

    # use VcXsrv instead of wslg
    sessionVariables.DISPLAY = "$(cat /etc/resolv.conf | grep nameserver | awk '{print $2; exit;}'):0.0";

    # other
    sessionVariables.TZ = "Europe/Berlin";

    # unklar ob benötigt?
    # sessionVariables.XCURSOR_SIZE = 16;
    # sessionVariables.GDK_BACKEND = "x11";
    # sessionVariables.LIBGL_ALWAYS_INDIRECT = "1";
  };

  fonts.fontconfig.enable = true;

  home.packages =
    stable-packages
    ++ unstable-packages
    ++
    # FIXME: you can add anything else that doesn't fit into the above two lists in here
    [
      # pkgs.some-package
      # pkgs.unstable.some-other-package
    ];

  # FIXME: if you want to version your LunarVim config, add it to the root of this repo and uncomment the next line
  # home.file.".config/lvim/config.lua".source = ./lvim_config.lua;

  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    # TODO: unklar ?!
    direnv.enable = true;
    direnv.enableZshIntegration = true;
    direnv.nix-direnv.enable = true;


    git = {
      enable = true;
      package = pkgs.unstable.git;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "robert.stauch@fluxdev.de";
      userName = "Robert Stauch";
      extraConfig = {
        push = {
          default = "current";
          autoSetupRemote = true;
        };
        merge = {
          conflictstyle = "diff3";
        };
        diff = {
          colorMoved = "default";
        };
      };
    };

  };
}
