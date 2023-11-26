{ config
, pkgs
, username
, nix-index-database
, ...
}:
let
  vscode = import ./modules/vscode;
  firefox = import ./modules/firefox;
  chrome = import ./modules/chrome;
  java = import ./modules/java;
  broot = import ./modules/broot;
  zsh = import ./modules/zsh;
  intellij = import ./modules/intellij;
  db = import ./modules/db;

  unstable-packages = with pkgs.unstable; [
    bat
    bottom
    coreutils
    curl
    dos2unix
    du-dust
    fd
    findutils
    fx # terminal json viewer
    git-crypt
    gron # Make JSON greppable, https://github.com/tomnomnom/gron
    htop
    httpie
    jq
    just
    keepassxc
    killall
    lazydocker
    mc
    nerdfonts
    nodejs_18
    openssl
    p7zip
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

    _1password-gui
  ];

  stable-packages = with pkgs; [
    postman

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
    chrome
    java
    broot
    zsh
    intellij
    db
  ];

  home.stateVersion = "22.11";

  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
    name = "phinger-cursors";
    package = pkgs.phinger-cursors;
    size = 16;
  };

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


  programs = {
    home-manager.enable = true;
    nix-index.enable = true;
    nix-index.enableZshIntegration = true;
    nix-index-database.comma.enable = true;

    # see
    # https://determinate.systems/posts/nix-home-env
    # https://determinate.systems/posts/nix-direnv
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
        core = {
          autocrlf = "input";
          safecrlf = true;
        };
        init = {
          defaultBranch = "master";
        };
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
