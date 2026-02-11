##----------------------------------------------------------------------------
## Terragrunt
##----------------------------------------------------------------------------

# tg-run-pick
#  - Interactive Terragrunt runner using fzf.
#
# Discovers directories containing terragrunt.hcl (using `fd` if available,
# otherwise falling back to `find`), lets you multi-select folders via fzf,
# and generates a Terragrunt command limited to those directories using
# --queue-include-dir.
#
# Usage:
#   tg-run-pick [command] [-- <extra terraform args>]
#
# Examples:
#   tg-run-pick
#   tg-run-pick plan
#   tg-run-pick apply -- -auto-approve
#
# Requirements:
#   - terragrunt
#   - fzf
#   - fd (optional, preferred) or find
#
tg-run() {
  local depth=4
  local include_external=0
  local tf_cmd="init"

  # Parse wrapper options + terraform command, stop at --
  while (($#)); do
    case "$1" in
    -d | --depth)
      shift
      depth="${1:-4}"
      shift
      ;;
    -e | --include-external)
      include_external=1
      shift
      ;;
    --)
      shift
      break
      ;;
    -*)
      echo "Unknown option: $1" >&2
      return 2
      ;;
    *)
      tf_cmd="$1"
      shift
      ;;
    esac
  done

  # Remaining args are terraform args
  local -a tf_args
  tf_args=("$@")

  # Discover terragrunt modules
  local -a dirs
  if command -v fd >/dev/null 2>&1; then
    IFS=$'\n' dirs=($(
      fd --type f --max-depth "$depth" '^terragrunt\.hcl$' . 2>/dev/null |
        sed 's|/terragrunt\.hcl$||' | sort -u
    ))
  else
    IFS=$'\n' dirs=($(
      find . -maxdepth "$depth" -type f -name terragrunt.hcl 2>/dev/null |
        sed 's|/terragrunt\.hcl$||' | sort -u
    ))
  fi

  if ((${#dirs[@]} == 0)); then
    echo "No terragrunt.hcl files found."
    return 1
  fi

  # Select directories via fzf
  local picked
  picked=$(
    printf '%s\n' "${dirs[@]}" |
      fzf --multi --height=60% --reverse \
        --prompt="terragrunt dirs> " \
        --bind 'tab:toggle+down,shift-tab:toggle+up' \
        --header $'TAB=select multiple | ENTER=confirm | ESC=cancel'
  ) || return 1

  [[ -z "$picked" ]] && return 1

  # Build include args
  local -a include_args
  while IFS= read -r d; do
    [[ -n "$d" ]] && include_args+=(--queue-include-dir "$d")
  done <<<"$picked"

  # Build full command array (safe execution)
  local -a full_cmd
  full_cmd=(
    terragrunt run --all
    --tf-forward-stdout
    --non-interactive
    "${include_args[@]}"
  )

  ((include_external)) && full_cmd+=(--queue-include-external)

  full_cmd+=(-- "$tf_cmd" -compact-warnings "${tf_args[@]}")

  # Pretty print command
  echo
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo "Command to run:"
  echo

  echo "terragrunt run --all --tf-forward-stdout --non-interactive \\"

  for ((i = 1; i <= ${#include_args[@]}; i += 2)); do
    printf "  %q %q \\\\\n" "${include_args[i]}" "${include_args[i + 1]}"
  done

  if ((include_external)); then
    echo "  --queue-include-external \\"
  fi

  printf "  -- %q -compact-warnings" "$tf_cmd"
  for arg in "${tf_args[@]}"; do
    printf " %q" "$arg"
  done
  echo

  echo
  echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
  echo

  # Confirmation
  read -q "REPLY?Run this command? [y/N] "
  echo

  if [[ "$REPLY" =~ ^[Yy]$ ]]; then
    echo "Running..."
    echo
    "${full_cmd[@]}"
  else
    echo "Cancelled."
  fi
}

function tg_prompt_info() {
  # dont show 'default' workspace in home dir
  [[ "$PWD" == ~ ]] && return
  # check if in terraform dir
  if [ -d .terraform ]; then
    workspace=$(terragrunt workspace show 2>/dev/null) || return
    echo "[${workspace}]"
  fi
}
compdef _terragrunt tg
setopt tg

# Terragrunt
alias tg='terragrunt'

alias tgp="terragrunt run --tf-forward-stdout -- plan -compact-warnings"
alias tg-plan="terragrunt run --tf-forward-stdout -- plan -compact-warnings"

alias tga="terragrunt run --tf-forward-stdout -- apply -compact-warnings"
alias tg-apply="terragrunt run --tf-forward-stdout -- apply -compact-warnings"

alias tgd="terragrunt run --tf-forward-stdout -- destroy -compact-warnings"
alias tg-destroy="terragrunt run --tf-forward-stdout -- destroy -compact-warnings"

alias tgpp="terragrunt run --tf-forward-stdout --all --parallelism 10 -- plan -compact-warnings"
alias tgpa="terragrunt run --tf-forward-stdout --all --parallelism 10 -- apply -compact-warnings"

# alias tgia="terragrunt run --all init --tf-forward-stdout --non-interactive"
# alias tg-init-all="terragrunt run --all init --tf-forward-stdout --non-interactive"
# alias tgpa="terragrunt run --all --tf-forward-stdout --non-interactive -- plan -compact-warnings"
# alias tg-plan-all="terragrunt run --all --tf-forward-stdout --non-interactive -- apply -compact-warnings"
# alias tgaa="terragrunt run --all --tf-forward-stdout --non-interactive -- apply -compact-warnings"
# alias tg-apply-all="terragrunt run --all --tf-forward-stdout --non-interactive -- apply -compact-warnings"

function tg-plan-parallel() {
  terragrunt run plan \
    --compact-warnings \
    --non-interactive \
    --parallelism 10 \
    --tf-forward-stdout "$@"
}

function tg-apply-parallel() {
  terragrunt run apply \
    --compact-warnings \
    --non-interactive \
    --parallelism 10 \
    --tf-forward-stdout "$@"
}

# shortcut with completions
compdef tf='terraform'
compdef tg='terragrunt'

# use same completion as terraform
# complete -o nospace -C terraform tf
# complete -o nospace -C terragrunt tg
complete -o nospace -C /opt/homebrew/bin/terragrunt -C /opt/homebrew/bin/terraform tg

tg() {
  terragrunt --tf-forward-stdout "$@"
}
compdef tg=terragrunt
