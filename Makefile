ZSHDIR := ~/.oh-my-zsh
HOMEBREWBIN := /opt/homebrew/bin/brew
GITCONFIG := ~/.gitconfig
GITIGNORE := ~/.gitignore
VSCODE_EXTENSIONS := vscodevim.vim ms-azuretools.vscode-docker eamodio.gitlens golang.go ms-kubernetes-tools.vscode-kubernetes-tools

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

bootstrap: macos-defaults homebrew ohmyzsh gitconfig vscode-setup ssh-keys ## bootstrap new laptop

macos-defaults: ## update macos settings
	@defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@mkdir -p ~/Documents/screenshots
	@defaults write com.apple.screencapture location ~/Documents/screenshots && killall SystemUIServer
  
ohmyzsh: | $(ZSHDIR) ## setup zsh
	@rm -rf ~/.zshrc
	@ln -s $(MAKEFILE_DIR)/dotfiles/.zshrc ~/.zshrc

gitconfig: ## setup gitconfig
	@rm -rf $(GITCONFIG)
	@ln -s $(MAKEFILE_DIR)/dotfiles/.gitconfig $(GITCONFIG)
	@ln -s $(MAKEFILE_DIR)/dotfiles/.gitignore $(GITIGNORE)

vim-setup: ## setup vim
	@rm -rf ~/.vimrc
	@ln -s $(MAKEFILE_DIR)/dotfiles/.vimrc ~/.vimrc
	@rm -rf ~/.vim
	@ln -s $(MAKEFILE_DIR)/.vim ~/.vim

homebrew: | $(HOMEBREWBIN) ## install homebrew
	@echo "Homebrew is installed"
	@brew bundle

vscode-setup: homebrew ## setup vscode
	for EXTENSION in $(VSCODE_EXTENSIONS) ; do code --force --install-extension $$EXTENSION; done
	@defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
	@defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
	@defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false

ssh-keys: ## generate ssh key for this machine
	@ssh-keygen -t rsa -b 4096

$(ZSHDIR):
	@curl -fsSL https://raw.github.com/ohmyzsh/ohmyzsh/master/tools/install.sh | sh -

$(HOMEBREWBIN):
	curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh | bash -

.PHONY: ohmyzsh help bootstrap macos-defaults ohmyzsh gitconfig vim-setup homebrew vscode-setup ssh-keys
