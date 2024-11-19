#!/usr/bin/env zsh

## ---------------------------------------------------------
## Settings / Options
## ---------------------------------------------------------

## speed up time machine backups
# sudo sysctl debug.lowpri_throttle_enabled=0
# restore
# sudo sysctl debug.lowpri_throttle_enabled=1

## enable window drag with ctrl+cmd + mouse
# to remove
# defaults delete -g NSWindowShouldDragOnGesture
defaults write -g NSWindowShouldDragOnGesture -bool true

# remove dock animation
# restore default
# defaults delete com.apple.dock autohide-time-modifier;killall Dock
defaults write com.apple.dock autohide-time-modifier -int 0;killall Dock

# set ultra fast dock hide
defaults write com.apple.dock autohide-time-modifier -float 0.12;killall Dock

# Enable key repeat
defaults write -g ApplePressAndHoldEnabled -bool true
defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false

## ---------------------------------------------------------
## Packages
## ---------------------------------------------------------

# Install brew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || \
    /bin/zsh -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"


## Install brew formulas
brew tap homebrew/cask-fonts
brew tap hashicorp/tap

brew install --cask font-cousine-nerd-font
brew install --cask the-unarchiver
# brew install --cask xmind

brew install zsh
brew install zsh-autosuggestions
brew install zsh-completions
brew install zsh-syntax-highlighting
brew install zsh-fast-syntax-highlighting
brew install pyenv
brew install alacritty
brew install 1password
brew install 1password-cli
brew install ripgrep
brew install eza
brew install bat
brew install fd
brew install fzf
brew install aws-vault
brew install awscli
brew install git
brew install bash
brew install bash-completions
brew install openssl
brew install gnupg
brew install go
brew install tmux
brew install neovim
brew install direnv
brew install jq
brew install p7zip
brew install tenv
# brew install pinentry
# brew install pinentry-mac
# brew install yubikey-agent
# brew install ykman

