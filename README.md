# macos-config

Personal macOS configuration managed with [chezmoi](https://www.chezmoi.io/).

## Layout

The files under `home/` are chezmoi's source state. The Makefile installs
packages, applies dotfiles, and configures macOS defaults.

The repository uses `.chezmoiroot`, so chezmoi reads source-state entries from
`home/` without treating repository support files such as `Brewfile` and this
README as files that belong in `$HOME`.

## Preview changes

From the repository root:

```sh
chezmoi --source . diff
```

Review the diff before applying anything. When it looks correct:

```sh
make dotfiles
```

The `dotfiles` target installs packages from the Brewfile, including chezmoi,
then applies the source state from this checkout.

After starting tmux for the first time, press `prefix + I` to install the
plugins declared in the tmux configuration with TPM.

## Set up a new Mac

The bootstrap script installs Apple's Command Line Tools when necessary, clones
this repository, installs the Brewfile, and applies the dotfiles with chezmoi:

```sh
GITHUB_WORKSPACE=/path/to/github/workspace curl -Ls https://raw.githubusercontent.com/rocpatel/macos-config/main/bootstrap | sh
```

If Command Line Tools were not already present, let their installer finish and
then run the command again.

SSH-key generation is deliberately separate and will refuse to overwrite an
existing Ed25519 key:

```sh
make ssh-key
```

## Set up with chezmoi directly

Install chezmoi, initialize this repository, inspect the proposed changes, and
only then apply them:

```sh
brew install chezmoi
chezmoi init rocpatel/macos-config
chezmoi diff
chezmoi apply --verbose
```
