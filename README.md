# home-manager
[![check](https://github.com/vaporif/nix-darwin/actions/workflows/check.yaml/badge.svg?branch=main)](https://github.com/vaporif/nix-darwin/actions/workflows/check.yaml)

This is my personal configuration for [nix-darwin](https://github.com/nix-darwin/nix-darwin)

# setup

1. Clone this repo
2. Install [homebrew](https://brew.sh/)
4. Install [nix](https://nixos.org/download)
5. Install [nix-darwin](https://github.com/nix-darwin/nix-darwin)

Run the initial setup which will build all the derivations which may take a while.

5. Override /etc/nix-darwin dir with this repo

Make sure to update username & home path in `flake.nix`
```
users.users.vaporif = {
  name = "vaporif";
  home = "/Users/vaporif";
};

6. Apply config
```shell
darwin-rebuild switch
```

7. Allow direnv .envrc for default devshell


```shell
direnv allow ~
```
## Learning

- https://nix.dev/recommended-reading
