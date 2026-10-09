#
# List of commands to install skills and AI tools faster
#

mattpocock-install-skills() {
  if [[ "$1" == "--help" || "$1" == "-h" ]]; then
    cat <<'EOF'
Usage:
  mattpocock-install-skills [skill] [options]

Arguments:
  skill                 Name of the skill to install

Options:
  -g, --global          Install globally
  -a, --agent <agent>   Install for a specific agent
  -h, --help            Show this help message

Examples:
  # Install all skills locally
  mattpocock-install-skills

  # Install a single skill locally
  mattpocock-install-skills pr

  # Install a single skill globally
  mattpocock-install-skills pr --global

  # Install a single skill for Claude Code
  mattpocock-install-skills pr --agent claude-code

  # Install a single skill globally for Claude Code
  mattpocock-install-skills pr --global --agent claude-code
EOF
    return 0
  fi

  local SKILL=""
  local GLOBAL=false
  local AGENT=""

  while [[ $# -gt 0 ]]; do
    case "$1" in
      -g|--global)
        GLOBAL=true
        ;;
      -a|--agent)
        AGENT="$2"
        shift
        ;;
      *)
        [[ -z "$SKILL" ]] && SKILL="$1"
        ;;
    esac
    shift
  done

  local CMD=(
    npx skills@latest add mattpocock/skills
  )

  [[ -n "$SKILL" ]] && CMD+=(--skill "$SKILL")
  [[ -n "$AGENT" ]] && CMD+=(--agent "$AGENT")
  $GLOBAL && CMD+=(-g)

  echo "Running: ${CMD[*]}"
  "${CMD[@]}"
}

