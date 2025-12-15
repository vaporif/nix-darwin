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

## Working with SOPS Secrets

Secrets are encrypted using [SOPS](https://github.com/getsops/sops) with age encryption.

### Initial Setup

1. Generate an age key (if you don't have one):
   ```shell
   mkdir -p ~/.config/sops/age
   age-keygen -o ~/.config/sops/age/key.txt
   ```

2. Add your public key to `.sops.yaml`:
   ```yaml
   keys:
     - &user age1...your-public-key...
   creation_rules:
     - path_regex: secrets/.*\.yaml$
       key_groups:
         - age:
             - *user
   ```

3. Re-encrypt existing secrets with your key (if inheriting this config):
   ```shell
   sops updatekeys secrets/secrets.yaml
   ```

### Editing Secrets

```shell
sops secrets/secrets.yaml
```

This opens your `$EDITOR` with the decrypted file. Changes are re-encrypted on save.

### Referencing Secrets in Configuration

In your nix files, reference secrets via:
```nix
config.sops.secrets.<secret-name>.path
```

Example from `shell.nix`:
```nix
export TAVILY_API_KEY="$(cat /run/secrets/tavily-key)"
```

### Adding New Secrets

1. Edit `secrets/secrets.yaml` and add your secret
2. Define it in your nix config (e.g., `system.nix`):
   ```nix
   sops.secrets.my-new-secret = { };
   ```
3. Reference via `/run/secrets/my-new-secret`

## Learning

- https://nix.dev/recommended-reading
