#!/usr/bin/env bash
set -Eeuo pipefail
IFS=$'\n\t'

# -----------------------------
# Config
# -----------------------------
INSTALL_DIR="${HOME}"
REPO_DIR="${HOME}/dotfiles"
DOTFILES_GIT="https://github.com/boogy/dotfiles.git"

# If you want to link scripts without sudo, prefer ~/bin (already in MANAGED_FILES)
SYSTEM_BIN="/usr/local/bin"

MANAGED_PATHS=(
  "$HOME/bin"
  "$HOME/.zshrc"
  "$HOME/.zsh"
  "$HOME/.bash"
  "$HOME/.bash_aliases"
  "$HOME/.vim"
  "$HOME/.vimrc"
  "$HOME/.tmux.conf"
)

# Exclude some ~/.config entries from being linked
# (names as they appear under dotfiles/.config/)
CONFIG_EXCLUDE=(
  "scripts" # handled separately below
  "kanata"
)

# For scripts directory under .config
SCRIPTS_SUBDIR=".config/scripts"

# Behavior flags
CLEAN="${1:-N}"         # Y -> replace existing
DRY_RUN="${DRY_RUN:-0}" # DRY_RUN=1 ./install.sh
BACKUP_DIR="${HOME}/.dotfiles_backup/$(date +%Y%m%d-%H%M%S)"

# -----------------------------
# Helpers
# -----------------------------
log() { printf '[+] %s\n' "$*"; }
warn() { printf '[!] %s\n' "$*" >&2; }
die() {
  printf '[-] %s\n' "$*" >&2
  exit 1
}

run() {
  if [[ "$DRY_RUN" == "1" ]]; then
    printf '[DRY] %q ' "$@"
    printf '\n'
  else
    "$@"
  fi
}

in_exclude_list() {
  local name="$1"
  local x
  for x in "${CONFIG_EXCLUDE[@]}"; do
    [[ "$name" == "$x" ]] && return 0
  done
  return 1
}

# Backup an existing path (file/dir/symlink) before replacing
backup_path() {
  local target="$1"
  [[ -e "$target" || -L "$target" ]] || return 0
  run mkdir -p "$BACKUP_DIR"
  local base
  base="$(basename "$target")"
  log "Backing up $target -> $BACKUP_DIR/$base"
  run mv "$target" "$BACKUP_DIR/$base"
}

# Link src -> dest, safely
safe_link() {
  local src="$1"
  local dest="$2"

  # If already correct symlink, do nothing
  if [[ -L "$dest" ]]; then
    local current
    current="$(readlink "$dest" || true)"
    if [[ "$current" == "$src" ]]; then
      log "Already linked: $dest -> $src"
      return 0
    fi
  fi

  if [[ -e "$dest" || -L "$dest" ]]; then
    if [[ "$CLEAN" =~ ^[Yy]$ ]]; then
      backup_path "$dest"
    else
      warn "Exists, skipping (set CLEAN=Y to replace): $dest"
      return 0
    fi
  fi

  run ln -sfn "$src" "$dest"
  log "Linked: $dest -> $src"
}

# -----------------------------
# Clone / update repo
# -----------------------------
log "Ensuring install dir exists: $INSTALL_DIR"
run mkdir -p "$INSTALL_DIR"

if [[ ! -d "$REPO_DIR/.git" ]]; then
  log "Cloning dotfiles into $REPO_DIR"
  run git clone "$DOTFILES_GIT" "$REPO_DIR"
else
  log "Updating dotfiles in $REPO_DIR"
  run git -C "$REPO_DIR" pull --ff-only || warn "git pull failed; continuing"
fi

# -----------------------------
# Link managed paths (home dotfiles)
# -----------------------------
log "Linking managed paths into $HOME"
for dest in "${MANAGED_PATHS[@]}"; do
  name="$(basename "$dest")"
  src="$REPO_DIR/$name"

  # Special-case: linking a directory like ~/bin may exist in repo as "bin"
  # This assumes your repo contains entries named exactly like basename(dest).
  [[ -e "$src" ]] || {
    warn "Missing in repo, skipping: $src"
    continue
  }

  safe_link "$src" "$dest"
done

# -----------------------------
# Link ~/.config entries with exclusions
# -----------------------------
log "Linking ~/.config entries"
run mkdir -p "$HOME/.config"

if [[ -d "$REPO_DIR/.config" ]]; then
  shopt -s nullglob dotglob
  for src in "$REPO_DIR/.config/"*; do
    name="$(basename "$src")"

    # skip excluded names
    if in_exclude_list "$name"; then
      log "Excluded ~/.config/$name"
      continue
    fi

    safe_link "$src" "$HOME/.config/$name"
  done
else
  warn "No .config directory in repo"
fi

# -----------------------------
# Link scripts
# -----------------------------
log "Linking scripts from $REPO_DIR/$SCRIPTS_SUBDIR to $SYSTEM_BIN"
if [[ -d "$REPO_DIR/$SCRIPTS_SUBDIR" ]]; then
  shopt -s nullglob
  for src in "$REPO_DIR/$SCRIPTS_SUBDIR/"*; do
    [[ -f "$src" ]] || continue
    [[ -x "$src" ]] || {
      warn "Not executable, skipping: $src"
      continue
    }

    dest="$SYSTEM_BIN/$(basename "$src")"
    if [[ "$DRY_RUN" == "1" ]]; then
      run sudo ln -sfn "$src" "$dest"
    else
      sudo ln -sfn "$src" "$dest"
    fi
    log "Linked: $dest -> $src"
  done
else
  warn "No scripts dir: $REPO_DIR/$SCRIPTS_SUBDIR"
fi

# -----------------------------
# Neovim/Vim compatibility
# -----------------------------
log "Linking NeoVim/Vim compatibility"
safe_link "$HOME/.config/nvim/init.vim" "$HOME/.vimrc"
safe_link "$HOME/.config/nvim" "$HOME/.vim"
run mkdir -p "$HOME/.vim"
safe_link "$HOME/.config/nvim" "$HOME/.vim/nvim"

# -----------------------------
# Firefox user.js copy
# -----------------------------
case "$(uname -s)" in
Darwin) firefox_base="$HOME/Library/Application Support/Firefox" ;;
Linux) firefox_base="$HOME/.mozilla/firefox" ;;
*)
  warn "Unsupported OS for Firefox user.js copy"
  firefox_base=""
  ;;
esac

if [[ -n "${firefox_base:-}" ]]; then
  profiles_ini="$firefox_base/profiles.ini"
  userjs_src="$REPO_DIR/deploy/conf/firefox/user.js"

  if [[ -f "$profiles_ini" && -f "$userjs_src" ]]; then
    log "Copying user.js to all Firefox profiles..."
    awk -F= '/^Path=/{print $2}' "$profiles_ini" | while read -r path; do
      profile_dir="$firefox_base/$path"
      [[ -d "$profile_dir" ]] || continue
      run cp "$userjs_src" "$profile_dir/user.js"
      log "Copied to $profile_dir"
    done
  else
    warn "Firefox profiles.ini or user.js not found; skipping"
  fi
fi

# -----------------------------
# Ensure aliases are sourced + VSCode on macOS
# -----------------------------
case "$(uname -s)" in
Linux)
  if [[ -f "$HOME/.bashrc" ]]; then
    grep -qE '\.bash_aliases' "$HOME/.bashrc" || echo 'source ~/.bash_aliases' >>"$HOME/.bashrc"
    run chmod 0700 "$HOME/.bashrc"
  fi
  ;;

Darwin)
  run touch "$HOME/.profile"
  run chmod 0700 "$HOME/.profile"
  grep -qE '\.bash_aliases' "$HOME/.profile" || echo 'source ~/.bash_aliases' >>"$HOME/.profile"

  # VS Code (stable) - adjust if you use Insiders/VSCodium
  vscode_user_dir="$HOME/Library/Application Support/Code/User"
  if [[ -d "$REPO_DIR/deploy/conf/VSCode/User" ]]; then
    run mkdir -p "$(dirname "$vscode_user_dir")"
    safe_link "$REPO_DIR/deploy/conf/VSCode/User" "$vscode_user_dir"
  fi
  ;;

*)
  warn "Unsupported OS: $(uname -s)"
  ;;
esac

log "Done."
if [[ "$CLEAN" =~ ^[Yy]$ ]]; then
  log "Backups (if any) stored in: $BACKUP_DIR"
fi
