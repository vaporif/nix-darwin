{fzf-git-sh-package, ...}: {
  programs = {
    ripgrep.enable = true;
    fd.enable = true;
    bat.enable = true;

    tealdeer = {
      enable = true;
      settings.updates.auto_update = true;
    };

    nix-index = {
      enable = true;
      enableZshIntegration = true;
    };

    jq.enable = true;

    yazi = {
      enable = true;
      enableZshIntegration = true;
    };

    eza = {
      enable = true;
      enableZshIntegration = true;
    };

    zoxide = {
      enable = true;
      enableZshIntegration = true;
    };

    carapace = {
      enable = true;
      enableZshIntegration = true;
    };

    direnv = {
      enable = true;
      enableZshIntegration = true;
      nix-direnv.enable = true;
      stdlib = builtins.readFile ../config/direnvrc;
      config.global.hide_env_diff = true;
    };

    atuin = {
      enable = true;
      enableZshIntegration = true;
    };

    fzf = {
      enable = true;
      enableZshIntegration = true;
      defaultCommand = "fd --type f --hidden --follow --exclude .git";
      fileWidgetCommand = "fd --type f --hidden --follow --exclude .git";
      historyWidgetOptions = [
        "--no-sort"
        "--tiebreak=index"
      ];
    };

    starship = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        format = ''
          $directory$git_branch$git_state$git_status$cmd_duration$line_break$character
        '';

        directory = {
          format = "[$path]($style)[$read_only]($read_only_style) ";
          style = "bold blue";
          truncation_length = 3;
          truncate_to_repo = true;
          read_only = " 🔒";
          read_only_style = "red";
        };

        character = {
          success_symbol = "[❯](bold green)";
          error_symbol = "[❯](bold red)";
          vimcmd_symbol = "[❮](bold cyan)";
        };

        git_branch = {
          format = "[ $branch]($style)";
          style = "bold cyan";
        };

        git_status = {
          format = "[$all_status$ahead_behind]($style)";
          conflicted = "⚔️";
          ahead = "⇡$count";
          behind = "⇣$count";
          diverged = "⇕⇡$ahead_count⇣$behind_count";
          untracked = "🆕$count";
          stashed = "📦$count";
          modified = "📝$count";
          staged = "✅$count";
          renamed = "🔄$count";
          deleted = "🗑️$count";
          style = "bold yellow";
        };

        git_state = {
          format = ''\([$state( $progress_current/$progress_total)]($style)\) '';
          style = "bold yellow";
        };

        cmd_duration = {
          format = "[⏱️ $duration]($style) ";
          style = "bold yellow";
          min_time = 2000;
        };
      };
    };

    zsh = {
      enable = true;
      enableCompletion = true;
      autosuggestion = {
        enable = true;
        highlight = "fg=#939f91,bold";
      };
      syntaxHighlighting.enable = true;
      history = {
        size = 50000;
        save = 50000;
        ignoreDups = true;
        ignoreSpace = true;
        share = true;
        extended = true;
        expireDuplicatesFirst = true;
      };
      shellAliases = {
        t = "yy";
        g = "lazygit";
        a = "claude";
        ap = "claude --print";
        ai = "claude --dangerously-skip-permissions";
        ar = "claude --resume";
        ls = "eza -a";
        cat = "bat";
        e = "nvim";
        x = "exit";
        mcp-scan = "uvx mcp-scan@latest";
        # Project templates
        init-solana = "nix flake init -t github:vaporif/nix-devshells#solana";
        init-rust = "nix flake init -t github:vaporif/nix-devshells#rust";
      };
      initContent = ''
        ulimit -Sn 4096
        ulimit -Sl unlimited
        source ${fzf-git-sh-package}/bin/fzf-git.sh
        bindkey '^F' fzf-file-widget
        bindkey -r '^T'
      '';
    };
  };
}
