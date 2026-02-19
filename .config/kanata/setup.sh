#!/usr/bin/env bash
set -euo pipefail

# setup-kanata-launchdaemon.sh
#
# Installs Kanata as a *root* LaunchDaemon so it starts automatically on boot.
# This is the typical workaround on macOS when Kanata needs root privileges
# (e.g., to access the VirtualHID/vhidd_server path under /Library/.../rootonly).
#
# Usage:
#   sudo ./setup-kanata-launchdaemon.sh /absolute/path/to/kanata_config.kbd
#
# What it does:
#   - Detects kanata binary path
#   - Creates /Library/LaunchDaemons/com.kanata.keyboard.plist
#   - Writes logs to /var/log/kanata/kanata.{out,err}.log
#   - Loads & enables the LaunchDaemon

if [[ "${EUID}" -ne 0 ]]; then
  echo "ERROR: Please run as root: sudo $0 /absolute/path/to/config.kbd" >&2
  exit 1
fi

if [[ $# -ne 1 ]]; then
  echo "Usage: sudo $0 /absolute/path/to/kanata_config.kbd" >&2
  exit 1
fi

CONFIG_PATH="$1"

if [[ ! -f "$CONFIG_PATH" ]]; then
  echo "ERROR: Config file not found: $CONFIG_PATH" >&2
  exit 1
fi

# Resolve to absolute path
CONFIG_PATH="$(cd "$(dirname "$CONFIG_PATH")" && pwd)/$(basename "$CONFIG_PATH")"

# Find kanata binary
KANATA_BIN=""
if command -v kanata >/dev/null 2>&1; then
  KANATA_BIN="$(command -v kanata)"
else
  # Common Homebrew paths fallback
  for p in /opt/homebrew/bin/kanata /usr/local/bin/kanata; do
    if [[ -x "$p" ]]; then
      KANATA_BIN="$p"
      break
    fi
  done
fi

if [[ -z "$KANATA_BIN" ]]; then
  echo "ERROR: kanata not found in PATH or common locations." >&2
  echo "Install it first (e.g., via Homebrew) and re-run." >&2
  exit 1
fi

PLIST_PATH="/Library/LaunchDaemons/com.kanata.keyboard.plist"
LOG_DIR="/tmp/kanata"
OUT_LOG="${LOG_DIR}/kanata.out.log"
ERR_LOG="${LOG_DIR}/kanata.err.log"

mkdir -p "$LOG_DIR"
chmod 755 "$LOG_DIR"
touch "$OUT_LOG" "$ERR_LOG"
chmod 644 "$OUT_LOG" "$ERR_LOG"

# For launchd, it's safer to not rely on PATH; pass absolute binary path.
cat >"$PLIST_PATH" <<EOF
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN"
 "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
  <dict>
    <key>Label</key>
    <string>com.kanata.keyboard</string>

    <key>ProgramArguments</key>
    <array>
      <string>${KANATA_BIN}</string>
      <string>-c</string>
      <string>${CONFIG_PATH}</string>
      <string>--quiet</string>
      <string>--no-wait</string>
      <string>--nodelay</string>
    </array>

    <!-- Start at boot -->
    <key>RunAtLoad</key>
    <true/>

    <!-- Restart if it crashes -->
    <key>KeepAlive</key>
    <true/>

    <!-- Logs -->
    <key>StandardOutPath</key>
    <string>${OUT_LOG}</string>
    <key>StandardErrorPath</key>
    <string>${ERR_LOG}</string>

    <!-- Make launchd kill the old instance on reload -->
    <key>ProcessType</key>
    <string>Interactive</string>
  </dict>
</plist>
EOF

# Permissions required by launchd for LaunchDaemons
chown root:wheel "$PLIST_PATH"
chmod 644 "$PLIST_PATH"

# If already loaded, unload first (ignore errors)
launchctl bootout system "$PLIST_PATH" >/dev/null 2>&1 || true

# Load/enable for the system domain
launchctl bootstrap system "$PLIST_PATH"
launchctl enable system/com.kanata.keyboard
launchctl kickstart -k system/com.kanata.keyboard

echo "✅ Installed LaunchDaemon: $PLIST_PATH"
echo "✅ Kanata binary:          $KANATA_BIN"
echo "✅ Kanata config:          $CONFIG_PATH"
echo "✅ Logs:"
echo "   - $OUT_LOG"
echo "   - $ERR_LOG"
echo
echo "Check status:"
echo "  launchctl print system/com.kanata.keyboard"
echo
echo "Tail logs:"
echo "  tail -f '$OUT_LOG' '$ERR_LOG'"
echo
echo "Uninstall:"
echo "  sudo launchctl bootout system '$PLIST_PATH'"
echo "  sudo rm -f '$PLIST_PATH'"
echo "  sudo rm -rf '$LOG_DIR'"
