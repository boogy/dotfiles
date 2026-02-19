#!/usr/bin/env zsh
set -euo pipefail
IFS=$'\n\t'

# ------------------------------------------------------------------------------
# macOS Bootstrap Script
# ------------------------------------------------------------------------------
#
# This script:
#   - Applies macOS UI defaults
#   - Installs Homebrew (if missing)
#   - Installs all packages using the Brewfile located in the same directory
#
#       brew bundle --file "<script_dir>/Brewfile"
#
# The Brewfile is the single source of truth.
#
# Environment variables:
#   DRY_RUN=1        -> Print commands without executing
#   NONINTERACTIVE=1 -> Non-interactive Homebrew install
#
# Example:
#   ./deploy/osx
#   DRY_RUN=1 ./deploy/osx
#
# Cleanup all software and only keep what's listed in Brewfile:
#   brew bundle cleanup --global --force
# ------------------------------------------------------------------------------

: "${DRY_RUN:=0}"
: "${NONINTERACTIVE:=0}"

# Resolve script directory (works even if executed via symlink)
SCRIPT_DIR="$(cd "$(dirname "${(%):-%N}")" && pwd)"
BREWFILE="$SCRIPT_DIR/Brewfile"

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    print -r -- "[DRY] $*"
  else
    eval "$@"
  fi
}

log()  { print -r -- "[+] $*"; }
warn() { print -r -- "[!] $*" >&2; }

is_macos() { [[ "$(uname -s)" == "Darwin" ]]; }

# ------------------------------------------------------------------------------
# Sanity Check
# ------------------------------------------------------------------------------
is_macos || { warn "This script is macOS-only."; exit 1; }

[[ -f "$BREWFILE" ]] || {
  warn "Brewfile not found at: $BREWFILE"
  exit 1
}

# ------------------------------------------------------------------------------
# macOS Defaults (UI tweaks)
# ------------------------------------------------------------------------------
apply_macos_defaults() {
  log "Applying macOS defaults…"

  log "Enable window drag with ctrl+cmd + mouse"
  run 'defaults write -g NSWindowShouldDragOnGesture -bool true'

  log "Dock behavior (instant hide)"
  run 'defaults write com.apple.dock autohide -bool true'
  run 'defaults write com.apple.dock autohide-delay -float 0'
  run 'defaults write com.apple.dock autohide-time-modifier -float 0.12'

  log "Enable key repeat (disable press-and-hold accents)"
  run 'defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false'
  run 'defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false'

  log "Avoid creating .DS_Store files on network volumes"
  run 'defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true'

  log "Set a fast keyboard repeat rate"
  run 'defaults write NSGlobalDomain KeyRepeat -int 0'

  log "Enable tap to click for current user and login screen"
  run 'defaults write com.apple.driver.AppleBluetoothMultitouch.trackpad Clicking -bool true'
  run 'defaults -currentHost write NSGlobalDomain com.apple.mouse.tapBehavior -int 1'
  run 'defaults write NSGlobalDomain com.apple.mouse.tapBehavior -int 1'

  log "Finder - Show filename extensions"
  run 'defaults write NSGlobalDomain AppleShowAllExtensions -bool true'

  log "Finder - Show path bar"
  run 'defaults write com.apple.finder ShowPathbar -bool true'

  log "Use list view in all Finder windows"
  run 'defaults write com.apple.finder FXPreferredViewStyle -string "Nlsv"'

  log "Finder - Allow quitting via COMMAND+Q"
  run 'defaults write com.apple.finder QuitMenuItem -bool true'

  log "Finder - Allow text selection in Quick Look"
  run 'defaults write com.apple.finder QLEnableTextSelection -bool true'

  log "Game Center - Disable Game Center"
  run 'defaults write com.apple.gamed Disabled -bool true'

  log "Restart Finder and Dock"
  run 'killall Finder >/dev/null 2>&1 || true'
  run 'killall Dock >/dev/null 2>&1 || true'
}

# ------------------------------------------------------------------------------
# Homebrew Setup
# ------------------------------------------------------------------------------
ensure_brew() {
  if command -v brew >/dev/null 2>&1; then
    log "Homebrew already installed."
    return 0
  fi

  log "Installing Homebrew…"
  if [[ "$NONINTERACTIVE" == "1" ]]; then
    run 'NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  else
    run '/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
  fi
}

ensure_brew_in_path() {
  if command -v brew >/dev/null 2>&1; then
    return 0
  fi

  if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
  elif [[ -x /usr/local/bin/brew ]]; then
    eval "$(/usr/local/bin/brew shellenv)"
  fi

  command -v brew >/dev/null 2>&1 || {
    warn "brew not found on PATH after installation."
    exit 1
  }
}

brew_install_from_brewfile() {
  log "Updating Homebrew…"
  run 'brew update'

  log "Installing packages from Brewfile…"
  run "brew bundle --file \"$BREWFILE\" --no-upgrade"
}

brew_cleanup() {
  log "Cleaning up Homebrew…"
  run 'brew cleanup -s || true'
}

# ------------------------------------------------------------------------------
# Main
# ------------------------------------------------------------------------------
main() {
  apply_macos_defaults
  ensure_brew
  ensure_brew_in_path
  brew_install_from_brewfile
  brew_cleanup

  log "Bootstrap complete."
}

main "$@"

