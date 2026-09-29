HOMEBREWBIN := $(if $(filter arm64,$(shell uname -m)),/opt/homebrew/bin/brew,/usr/local/bin/brew)
CHEZMOIBIN := $(dir $(HOMEBREWBIN))chezmoi
SSH_KEY := $(HOME)/.ssh/id_ed25519

# Get the path to this Makefile and directory
MAKEFILE_DIR := $(patsubst %/,%,$(dir $(abspath $(lastword $(MAKEFILE_LIST)))))

help: ## show help message
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m\033[0m\n"} /^[$$()% 0-9a-zA-Z_-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

bootstrap: macos-defaults dotfiles ## bootstrap new laptop

macos-defaults: ## update macos settings
	@defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
	@mkdir -p ~/Documents/screenshots
	@defaults write com.apple.screencapture location ~/Documents/screenshots && killall SystemUIServer
  
homebrew: | $(HOMEBREWBIN) ## install homebrew
	@echo "Homebrew is installed"
	@$(HOMEBREWBIN) bundle --file="$(MAKEFILE_DIR)/Brewfile"

dotfiles: homebrew ## install dotfiles with chezmoi
	@$(CHEZMOIBIN) --source "$(MAKEFILE_DIR)" apply --verbose

ssh-key: ## generate an optional Ed25519 SSH key
	@if [ -e "$(SSH_KEY)" ] || [ -e "$(SSH_KEY).pub" ]; then \
		echo "SSH key already exists: $(SSH_KEY)"; \
		exit 1; \
	fi
	@mkdir -p "$(dir $(SSH_KEY))"
	@ssh-keygen -t ed25519 -f "$(SSH_KEY)"

$(HOMEBREWBIN):
	/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" </dev/tty

.PHONY: help bootstrap macos-defaults homebrew dotfiles ssh-key
