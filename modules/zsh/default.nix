{ config
, pkgs
, ...
}:
let
  xclip = pkgs.unstable.xclip;
  bat = pkgs.unstable.bat;
  eza = pkgs.unstable.eza;
  lesspipe = pkgs.unstable.lesspipe;
  less = pkgs.unstable.less;
  vscode = pkgs.unstable.vscode;
in
{
  home.sessionVariables = {
    BAT_PAGER = "${less}/bin/less -RF --mouse --wheel-lines=3";
  };

  home.packages = [
    # requirements
    xclip
    bat
    eza

    # fzf preview
    lesspipe
    less
  ];

  # history = CTRL + R
  # subdirs filesearch = CTRL + T
  # alternativ: cd ** + TAB bzw cat ** + TAB um fuzzy search zu öffnen
  # enter subdir = ALT+C
  programs.fzf = {
    enable = true;
    enableBashIntegration = true;
    enableZshIntegration = true;

    fileWidgetOptions = [
      "--height=70% --preview '${pkgs.lib.getExe bat} --color=always --style=numbers --line-range=:1000 {}'"
    ];
  };

  # cdi = interactive, auch triggerbar mit cd xxx<SPACE><TAB>
  # cdi bla / = search from root dir
  programs.zoxide = {
    enable = true;
    enableBashIntegration = true;
    enableFishIntegration = true;
    enableZshIntegration = true;
    # would replace the cd command (doesn't work on Nushell / POSIX shells).
    options = [ "--cmd cd" ];
  };

  programs.zsh = {
    package = pkgs.unstable.zsh;
    enable = true;
    enableAutosuggestions = true;
    enableCompletion = true;

    envExtra = ''
      export PATH=$PATH:$HOME/.local/bin
    '';

    initExtra = ''
      unsetopt BEEP
      unsetopt LIST_BEEP
      unsetopt HIST_BEEP

      unsetopt notify # Don't print status of background jobs until a prompt is about to be printed

      setopt INC_APPEND_HISTORY
      setopt globdots

      # https://github.com/Freed-Wu/fzf-tab-source
      zstyle ':fzf-tab:complete:*' fzf-min-height 1000

      # preview directory's content with eza when completing cd
      # zstyle ':fzf-tab:complete:cd:*' fzf-preview '${pkgs.lib.getExe eza} -1ha --color=always --group-directories-first $realpath'

      # enable preview with bat/cat/less
      zstyle ':fzf-tab:complete:(bat|cat|less):*' fzf-preview '${pkgs.lib.getExe bat} --color=always --style=numbers --line-range=:1000 $realpath'

      eval "$(direnv hook zsh)"

      # from: https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/docker#settings
      zstyle ':completion:*:*:docker:*' option-stacking yes
      zstyle ':completion:*:*:docker-*:*' option-stacking yes

      # https://thevaluable.dev/zsh-completion-guide-examples/
      zstyle ':completion:*' completer _extensions _complete _approximate
      zstyle ':completion:*:descriptions' format '%F{green}-- %d --%f'
      zstyle ':completion:*' group-name ""
      zstyle ':completion:*:*:-command-:*:*' group-order alias builtins functions commands
      zstyle ':completion:*' squeeze-slashes true
      zstyle ':completion:*' matcher-list "" 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

      # mkcd is equivalent to takedir
      function mkcd takedir() {
        mkdir -p $@ && cd ''${@:$#}
      }

      function takeurl() {
        local data thedir
        data="$(mktemp)"
        curl -L "$1" > "$data"
        tar xf "$data"
        thedir="$(tar tf "$data" | head -n 1)"
        rm "$data"
        cd "$thedir"
      }

      function takegit() {
        git clone "$1"
        cd "$(basename ''${1%%.git})"
      }

      function take() {
        if [[ $1 =~ ^(https?|ftp).*\.(tar\.(gz|bz2|xz)|tgz)$ ]]; then
          takeurl "$1"
        elif [[ $1 =~ ^([A-Za-z0-9]\+@|https?|git|ssh|ftps?|rsync).*\.git/?$ ]]; then
          takegit "$1"
        else
          takedir "$@"
        fi
      }

      # https://lgug2z.com/articles/sensible-wordchars-for-most-developers/
      WORDCHARS='*?[]~=&;!#$%^(){}<>'
    '';
    autocd = true;

    shellAliases = {
      gc = "nix-collect-garbage --delete-old";
      refresh = "source ${config.home.homeDirectory}/.zshrc";

      l = "ls -lah --group-directories-first --color=auto";
      lsl = "${pkgs.lib.getExe eza} -la --group-directories-first --color=auto --no-user --no-permissions --header --no-time";
      cls = "clear";
      c = "clear";

      tree = "${pkgs.lib.getExe eza} --tree --level 3 --all --group-directories-first --no-permissions --no-time";
      br = "br --cmd ':open_preview'";
      j = "just";

      hmu = "cd ${config.home.homeDirectory}/projects/int/nix-config && sudo nixos-rebuild switch --flake .#nixos && gc && refresh";
      hme = "dot";
      dot = "${pkgs.lib.getExe vscode} ${config.home.homeDirectory}/projects/int/nix-config";

      pbcopy = "/mnt/c/Windows/System32/clip.exe";
      pbpaste = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe -command 'Get-Clipboard'";
      explorer = "/mnt/c/Windows/explorer.exe";

      idea = "idea-ultimate"; # blocks terminal
      ff = "firefox &";
    };
    history = {
      save = 10000;
      size = 100000;
      ignoreDups = true;
      ignoreSpace = true;
      expireDuplicatesFirst = true;
      extended = true;
    };
    historySubstringSearch.enable = true;

    plugins = [
      {
        # Replace zsh's default completion selection menu with fzf!
        # configuration https://github.com/Aloxaf/fzf-tab#configure
        name = "fzf-tab";
        src = with pkgs;
          fetchFromGitHub {
            owner = "Aloxaf";
            repo = "fzf-tab";
            rev = "c2b4aa5ad2532cca91f23908ac7f00efb7ff09c9";
            sha256 = "sha256-gvZp8P3quOtcy1Xtt1LAW1cfZ/zCtnAmnWqcwrKel6w=";
          };
      }
      {
        name = "fast-syntax-highlighting";
        src = "${pkgs.unstable.zsh-fast-syntax-highlighting}/share/zsh/site-functions";
      }
      {
        name = "zsh-nix-shell";
        file = "nix-shell.plugin.zsh";
        src = pkgs.fetchFromGitHub {
          owner = "chisui";
          repo = "zsh-nix-shell";
          rev = "v0.7.0";
          sha256 = "sha256-oQpYKBt0gmOSBgay2HgbXiDoZo5FoUKwyHSlUrOAP5E=";
        };
      }
    ];

    oh-my-zsh = {
      enable = true;
      # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins
      plugins = [
        "git"

        "sudo" # press esc twice.

        # alt + left = previous dir
        # alt + right = undo
        # alt + up = parent dir
        # alt + down = first child dir
        "dirhistory"

        "colored-man-pages"

        "zoxide"
        "mvn"
        # 1password
        # adb
        # aws
        # gcloud
        "docker"
        # "docker-compose"
        # gitflow ?
        # fzf ?

        # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/helm
        # "helm"

        # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/minikube
        # "minikube"

        # https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/kubectl
        # "kubectl"
      ];
      theme = "simple";
    };
  };
}
