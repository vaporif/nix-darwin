# Nix-darwin + home-manager
This is my personal configuration for [nix-darwin](https://github.com/nix-darwin/nix-darwin) with dotfiles and tools.

# setup

1. Clone this repo
2. Install [homebrew](https://brew.sh/)
4. Install [nix](https://determinate.systems/nix-installer/)
5. Install [nix-darwin](https://github.com/nix-darwin/nix-darwin)

Run the initial setup which will build all the derivations which may take a while.

6. Override /etc/nix-darwin dir with this repo

Update your machine name in `flake.nix`

```flake.nix
darwinConfigurations."MacBook-Pro"
```

Update username & home path in `flake.nix`
```flake.nix
users.users.vaporif = {
  name = "vaporif";
  home = "/Users/vaporif";
};
```

Inside `home.nix`
```home.nix
  home = {
        homeDirectory = "/Users/vaporif";
      username = "vaporif";

```
7. Apply config
```shell
sudo darwin-rebuild switch
```

8. Allow direnv .envrc for default devshell
```shell
direnv allow ~
```

## Learning

- https://nix.dev/recommended-reading
