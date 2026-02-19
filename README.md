# dotfiles

Personal configuration files for **Linux** and **macOS**.

This repository contains my shell, editor, terminal, and development environment configuration. The setup is designed to be:

- Idempotent
- Safe by default (no destructive overwrites)
- Symlink-based (single source of truth)
- Backup-aware when replacing files

---

# Installation

## Clone and install

```bash
git clone https://github.com/boogy/dotfiles.git
cd dotfiles
./install.sh
```

The installer will:

- Clone or update the repository into `~/dotfiles`
- Create symlinks for managed files
- Link `.config` directories (with optional exclusions)
- Link scripts into `/usr/local/bin`
- Configure Vim/NeoVim compatibility
- Copy `user.js` into all Firefox profiles (if present)

---

## Replace existing files (force mode)

By default, the installer **does not overwrite existing files**.

To replace existing managed files:

```bash
./install.sh Y
```

When `Y` is supplied:

- Existing files are backed up (not deleted)
- Backups are stored in:

```
~/.dotfiles_backup/<timestamp>/
```

---

## Remote installation (quick bootstrap)

Important:  
If you pass `Y`, existing managed files will be replaced (backed up first).

Safe mode (no overwrite):

```bash
wget -qO - https://raw.githubusercontent.com/boogy/dotfiles/master/install.sh | bash -s N
```

Force replace (with backup):

```bash
wget -qO - https://raw.githubusercontent.com/boogy/dotfiles/master/install.sh | bash -s Y
```

---

# Configuration Management

## Managed Files

Files managed by the installer are defined in the `MANAGED_PATHS` array inside `install.sh`.

Examples:

- `~/.zshrc`
- `~/.bash_aliases`
- `~/.vimrc`
- `~/.tmux.conf`
- `~/bin`
- `~/.config/*` (with exclusions)

---

## `.config` Exclusions

Some `.config` folders can be excluded from automatic linking.  
These are defined in the `CONFIG_EXCLUDE` array in `install.sh`.

Example:

```bash
CONFIG_EXCLUDE=(
  "scripts"
  "sensitive"
)
```

This allows keeping certain configuration directories local.

---

# Usage

## Ensure `.bash_aliases` is sourced

### Linux

```bash
echo "source ~/.bash_aliases" >> ~/.bashrc
```

### macOS

```bash
echo "source ~/.bash_aliases" >> ~/.profile
# or
echo "source ~/.bash_aliases" >> ~/.bash_profile
```

(The installer attempts to handle this automatically.)

---

# System Bootstrap

## macOS

```bash
bash ~/dotfiles/deploy/macos.sh
```

This will:

- Install Homebrew (if missing)
- Install required packages and fonts
- Configure the macOS development environment

The `Homebrew` packages can be installed without running the full bootstrap by using:

```bash
brew bundle --file=~/dotfiles/Brewfile
```

---

# Recommended Workflow

When updating your dotfiles:

```bash
cd ~/dotfiles
git pull
./install.sh
```
