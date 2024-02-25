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
  k8s = import ./modules/k8s;

  unstable-packages = with pkgs.unstable; [
    azure-cli
    bat
    bottom
    bruno # offline only postman replacement
    camunda-modeler
    corepack_18
    coreutils
    curl
    dos2unix
    du-dust
    fd
    findutils
    fx # terminal json viewer
    git-crypt
    git-credential-manager
    gron # Make JSON greppable, https://github.com/tomnomnom/gron
    htop
    httpie
    insomnia # postman alternative
    jq
    just
    keepassxc
    killall
    lazydocker
    microsoft-edge
    mc
    nerdfonts
    openssl
    p7zip
    python3
    # postman # currently 404
    procs
    q-text-as-data # Run SQL directly on CSV or TSV files, https://github.com/harelba/q
    ripgrep
    terraform
    tldr
    tree
    unzip
    wget
    xdg-utils
    xz
    zip

    _1password-gui
  ];

  stable-packages = with pkgs; [
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

    gnupg
    pass
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
    k8s
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


  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    pinentryFlavor = "tty";
    defaultCacheTtl = 31536000;
    maxCacheTtl = 31536000;
  };

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
      package = pkgs.gitFull;
      delta.enable = true;
      delta.options = {
        line-numbers = true;
        side-by-side = true;
        navigate = true;
      };
      userEmail = "robert.stauch@fluxdev.de";
      userName = "Robert Stauch";
      extraConfig = {
        credential.credentialStore = "gpg";
        credential.helper = "${pkgs.unstable.git-credential-manager}/bin/git-credential-manager";
        credential.useHttpPath = true;
        credential.cacheOptions = "--timeout 86400";
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
