ZSHDIR := ~/.oh-my-zsh
HOMEBREWBIN := /opt/homebrew/bin/brew
GITCONFIG := ~/.gitconfig
VSCODE_EXTENSIONS := vscodevim.vim ms-azuretools.vscode-docker eamodio.gitlens golang.go ms-kubernetes-tools.vscode-kubernetes-tools

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

ohmyzsh: | $(ZSHDIR) ## setup zsh
	@rm -rf ~/.zshrc
	@ln -s $(MAKEFILE_DIR)/dotfiles/.zshrc ~/.zshrc

gitconfig: ## setup gitconfig
	@rm -rf $(GITCONFIG)
	@ln -s $(MAKEFILE_DIR)/dotfiles/.gitconfig $(GITCONFIG)

homebrew: | $(HOMEBREWBIN) ## install homebrew
	@echo "Homebrew is installed"
	@brew install git nvm httpie jq yq gh awscli go
	@brew install --cask visual-studio-code iterm2 moom

vscode_setup: homebrew ## setup vscode
	for EXTENSION in $(VSCODE_EXTENSIONS) ; do code --force --install-extension $$EXTENSION; done
	@defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
	@defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
	@defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
	@defaults delete -g ApplePressAndHoldEnabled || true

ssh_keys: ## generate ssh key for this machine
	@ssh-keygen -t rsa -b 4096

$(ZSHDIR):
	@curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -

$(HOMEBREWBIN):
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash -

bootstrap: homebrew ohmyzsh gitconfig vscode_setup ssh_keys ## bootstrap new laptop

.PHONY: ohmyzsh help
