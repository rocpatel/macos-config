# macos-config

Personal macOS setup managed by the bootstrap script and Makefile. Homebrew
installs applications and command-line tools, while chezmoi applies the files
under `home/`.

## Set up a new Mac

Run the bootstrap script:

```sh
curl -Ls https://raw.githubusercontent.com/rocpatel/macos-config/main/bootstrap | sh
```

The script installs Apple's Command Line Tools when needed, clones this
repository to `~/Documents/workspace/github.com/rocpatel/macos-config`, and
runs `make bootstrap` from the checkout.

If the Command Line Tools installer opens, let it finish and then run the
bootstrap command again.

To use a different workspace directory, set `GITHUB_WORKSPACE`:

```sh
GITHUB_WORKSPACE=/path/to/github/workspace \
  curl -Ls https://raw.githubusercontent.com/rocpatel/macos-config/main/bootstrap | sh
```

## Use an existing checkout

Run these commands from the repository root:

```sh
make help
make bootstrap
```

`make bootstrap` applies the macOS defaults, installs everything in the
`Brewfile`, and applies the dotfiles with chezmoi. It is safe to run again when
the configuration changes.

The individual steps are also available:

```sh
make macos-defaults  # Apply macOS preferences
make homebrew        # Install and update Brewfile dependencies
make dotfiles        # Install dependencies and apply the dotfiles
make ssh-key         # Create an optional Ed25519 SSH key
```

The SSH-key target is intentionally separate from bootstrap and refuses to
overwrite an existing key.

## Preview dotfile changes

Before running `make dotfiles`, inspect what chezmoi will change:

```sh
chezmoi --source . diff
```

The `.chezmoiroot` file tells chezmoi to use `home/` as its source state, so
repository files such as the `Brewfile`, Makefile, and README are not copied to
the home directory.

## Finish tmux setup

After starting tmux for the first time, press `prefix + I` to install the
plugins declared in `.tmux.conf` with TPM.
