#compdef aws-sso.py

# Zsh completion for aws-sso.py
# Installation:
#   1. Copy this file to a directory in your $fpath (e.g., /usr/local/share/zsh/site-functions/)
#   2. Or add the directory containing this file to your $fpath in .zshrc:
#      fpath=(~/path/to/directory $fpath)
#   3. Reload completions: compinit

_aws-sso() {
  local -a actions pmsets accounts

  actions=(
    'add:Assign permission set to users/groups'
    'del:Remove permission set from users/groups'
    'delete:Remove permission set from users/groups'
    'sync:Sync specific permission sets from AWS to local cache'
    'sync-accounts:Sync AWS accounts from API to local cache'
    'init:Create example JSON files for accounts and permission sets'
  )

  # Load permission sets from cached file only (sorted alphabetically)
  pmsets=()
  local pmsets_file="${HOME}/.aws-sso-pmsets.json"
  if [[ -f "$pmsets_file" ]]; then
    # Extract keys from JSON file, sorted alphabetically
    local cached_pmsets=($(python3 -c "import json; print('\n'.join(sorted(json.load(open('$pmsets_file')).keys())))" 2>/dev/null))
    if [[ ${#cached_pmsets[@]} -gt 0 ]]; then
      pmsets=($cached_pmsets)
    fi
  fi

  # If no cached permission sets, show a message
  if [[ ${#pmsets[@]} -eq 0 ]]; then
    pmsets=('(run sync first)')
  fi

  # Load accounts from cached file (sorted alphabetically by name)
  # Format: 'account_id:account_name' - completes with ID, shows name for reference
  accounts=()
  local accounts_file="${HOME}/.aws-sso-accounts.json"
  if [[ -f "$accounts_file" ]]; then
    # Build completion entries as "id:name" format, sorted alphabetically by name
    local account_entries=($(python3 -c "
import json
try:
    with open('$accounts_file') as f:
        data = json.load(f)
    for name in sorted(data.keys()):
        print(f'{data[name]}:{name}')
except:
    pass
" 2>/dev/null))
    if [[ ${#account_entries[@]} -gt 0 ]]; then
      accounts=($account_entries)
    fi
  fi

  # If no cached accounts, show a message
  if [[ ${#accounts[@]} -eq 0 ]]; then
    accounts=('(run sync-accounts first)')
  fi

  _arguments -C \
    '(-A --action)'{-A,--action}'[Action to perform]:action:->actions' \
    '(-p --pmset-name)'{-p,--pmset-name}'[Permission set name]:permission set:->pmsets' \
    '(-P --pmset-names)'{-P,--pmset-names}'[List of permission set names for sync]:permission set names:->pmsets_multi' \
    '(-a --accounts)'{-a,--accounts}'[AWS account names or IDs (space-separated)]:account:->accounts' \
    '--pmset-arn[Permission set ARN]:ARN:_files' \
    '(-u --users)'{-u,--users}'[User names (space-separated)]:user:_files' \
    '(-g --groups)'{-g,--groups}'[Group names (space-separated)]:group:_files' \
    '(-f --pmsets-file)'{-f,--pmsets-file}'[Permission sets JSON file]:file:_files -g "*.json"' \
    '--accounts-file[Accounts JSON file]:file:_files -g "*.json"' \
    '--accounts-api-url[API URL for sync-accounts]:url:_urls' \
    '--use-full-names[Use full account names instead of slugs for sync-accounts]' \
    '(-w --workers)'{-w,--workers}'[Number of parallel workers]:workers:(1 2 3 5 10 15 20)' \
    '(- *)'{-h,--help}'[Show help message]' \
    && return 0

  case "$state" in
    actions)
      _describe -t actions 'action' actions
      ;;
    pmsets)
      # -V preserves our alphabetical sort order
      _describe -V -t pmsets 'permission set' pmsets
      ;;
    pmsets_multi)
      # For -P flag, allow multiple values; -V preserves sort order
      _describe -V -t pmsets 'permission set names' pmsets
      ;;
    accounts)
      # For -a flag, complete with ID, show name for reference
      # -V preserves our alphabetical sort order by name
      _describe -V -t accounts 'account (id:name)' accounts
      ;;
  esac

  return 0
}

_aws-sso "$@"

