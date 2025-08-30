{ pkgs, yamb-yazi, ... }:
{
  imports = [
    ./mcp-servers.nix
    ./packages.nix
    ./shell.nix
  ];

  home = {
    homeDirectory = "/Users/vaporif";
    username = "vaporif";
    stateVersion = "24.05";
  };

  programs = {
    home-manager.enable = true;

    gh.enable = true;
    lazygit.enable = true;

    wezterm = {
      enable = true;
      enableZshIntegration = true;
      extraConfig = builtins.readFile ../wezterm/init.lua;
    };

    git = {
      enable = true;
      userName = "Dmytro Onypko";
      userEmail = "vaporif@proton.me";
      aliases = {
        co = "checkout";
        cob = "checkout -b";
        discard = "reset HEAD --hard";
        fp = "fetch --all --prune";
      };
      # yeah signing is not cool since my ssh
      # keys are living inside macbook secure enclave hsm
      signing = {
        key = "AC03496CA69745FE";
        signByDefault = true;
        format = "openpgp";
      };

      extraConfig = {
        core = {
          editor = "nvim";
          pager = "delta";
        };
        pull.ff = "only";
        push.autoSetupRemote = true;
        gui.encoding = "utf-8";
        merge.conflictstyle = "diff3";
        init.defaultBranch = "main";
        rebase.autosquash = true;
        rebase.autostash = true;
        commit.verbose = true;
        diff.colorMoved = true;
        diff.algorithm = "histogram";
        feature.experimental = true;
        help.autocorrect = "prompt";
        branch.sort = "committerdate";
        interactive.diffFilter = "delta --color-only";
        delta.navigate = true;
      };
    };

    neovim = {
      viAlias = true;
      enable = true;
      extraPackages = with pkgs; [
        lua51Packages.luarocks
        lua51Packages.lua
        lua-language-server
        stylua
        typescript-language-server
        haskell-language-server
        basedpyright
        just-lsp
      ];
    };
  };

  home.file = {
    ".envrc".text = ''
        use flake github:vaporif/nix-devshells/b7d8485fa2ad3ffac873a6d83d12fb30172ef0a9
    '';
   ".ssh/config" = {
      source = ../.ssh/config;
    };
  };

  # XDG configuration files
  xdg.configFile."karabiner/karabiner.json".source = ../karabiner/karabiner.json;
  xdg.configFile."ncspot/config.toml".source = ../ncspot/config.toml;
  xdg.configFile."yazi/init.lua".source = ../yazi/init.lua;
  xdg.configFile."yazi/keymap.toml".source = ../yazi/keymap.toml;
  xdg.configFile."yazi/plugins/yamb.yazi/" = {
    source = yamb-yazi;
    recursive = true;
  };
  xdg.configFile.nvim.source = ../nvim;
  
  # Tidal configuration (from vim-tidal)
  xdg.configFile."tidal/Tidal.ghci".text = ''
    :set -XOverloadedStrings
    :set prompt ""

    import Sound.Tidal.Context

    import System.IO (hSetEncoding, stdout, utf8)
    hSetEncoding stdout utf8

    -- total latency = oLatency + cFrameTimespan
    tidal <- startTidal (superdirtTarget {oLatency = 0.1, oAddress = "127.0.0.1", oPort = 57120}) (defaultConfig {cVerbose = True, cFrameTimespan = 1/20})

    :{
    let only = (hush >>)
        p = streamReplace tidal
        hush = streamHush tidal
        panic = do hush
                   once $ sound "superpanic"
        list = streamList tidal
        mute = streamMute tidal
        unmute = streamUnmute tidal
        unmuteAll = streamUnmuteAll tidal
        unsoloAll = streamUnsoloAll tidal
        solo = streamSolo tidal
        unsolo = streamUnsolo tidal
        once = streamOnce tidal
        first = streamFirst tidal
        asap = once
        nudgeAll = streamNudgeAll tidal
        all = streamAll tidal
        resetCycles = streamResetCycles tidal
        setcps = asap . cps
        getcps = streamGetcps tidal
        getnow = streamGetnow tidal
        xfade i = transition tidal True (Sound.Tidal.Transition.xfadeIn 4) i
        xfadeIn i t = transition tidal True (Sound.Tidal.Transition.xfadeIn t) i
        histpan i t = transition tidal True (Sound.Tidal.Transition.histpan t) i
        wait i t = transition tidal True (Sound.Tidal.Transition.wait t) i
        waitT i f t = transition tidal True (Sound.Tidal.Transition.waitT f t) i
        jump i = transition tidal True (Sound.Tidal.Transition.jump) i
        jumpIn i t = transition tidal True (Sound.Tidal.Transition.jumpIn t) i
        jumpIn' i t = transition tidal True (Sound.Tidal.Transition.jumpIn' t) i
        jumpMod i t = transition tidal True (Sound.Tidal.Transition.jumpMod t) i
        jumpMod' i t p = transition tidal True (Sound.Tidal.Transition.jumpMod' t p) i
        mortal i lifespan release = transition tidal True (Sound.Tidal.Transition.mortal lifespan release) i
        interpolate i = transition tidal True (Sound.Tidal.Transition.interpolate) i
        interpolateIn i t = transition tidal True (Sound.Tidal.Transition.interpolateIn t) i
        clutch i = transition tidal True (Sound.Tidal.Transition.clutch) i
        clutchIn i t = transition tidal True (Sound.Tidal.Transition.clutchIn t) i
        anticipate i = transition tidal True (Sound.Tidal.Transition.anticipate) i
        anticipateIn i t = transition tidal True (Sound.Tidal.Transition.anticipateIn t) i
        forId i t = transition tidal False (Sound.Tidal.Transition.mortalOverlay t) i
        d1 = p 1 . (|< orbit 0)
        d2 = p 2 . (|< orbit 1)
        d3 = p 3 . (|< orbit 2)
        d4 = p 4 . (|< orbit 3)
        d5 = p 5 . (|< orbit 4)
        d6 = p 6 . (|< orbit 5)
        d7 = p 7 . (|< orbit 6)
        d8 = p 8 . (|< orbit 7)
        d9 = p 9 . (|< orbit 8)
        d10 = p 10 . (|< orbit 9)
        d11 = p 11 . (|< orbit 10)
        d12 = p 12 . (|< orbit 11)
        d13 = p 13
        d14 = p 14
        d15 = p 15
        d16 = p 16
    :}

    :{
    let getState = streamGet tidal
        setI = streamSetI tidal
        setF = streamSetF tidal
        setS = streamSetS tidal
        setR = streamSetR tidal
        setB = streamSetB tidal
    :}

    :set prompt "tidal> "
    :set prompt-cont ""

    default (Pattern String, Integer, Double)
  '';
}
