## CREDIT: <github.com/mislav/dotfiles/blob/master/zshrc>.

## setup
autoload colors; colors;
export LSCOLORS="Gxfxcxdxbxegedabagacad"
setopt prompt_subst

_EMOJIS=(🥯 🦆 🦉 🥓 🦄 🦀 🖕 🍣 🍤 🍥 🍡 🥃 🥞 🤯 🤪 🤬 🤮 🤫 🤭 🧐 🐕 🦖 👾 🐉 🐓 🐋 🐌 🐢 ➜ ➤ ➥ ❯ ✗ ⚡ ► λ ✘)

# echo "\ue0b0 \u00b1 \ue0a0 \u27a6 \u2718 \u26a1 \u2699"
#  ±  ➦ ✘ ⚡ ⚙
_git_emojis=( ±  ➦ ✘ ⚡ ⚙)

## prompt
ZSH_THEME_GIT_PROMPT_PREFIX="%{$reset_color%}%{$fg[green]%}${_git_emojis[3]} ["
ZSH_THEME_GIT_PROMPT_SUFFIX="]%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_DIRTY="%{$fg[red]%}${_git_emojis[6]}%{$reset_color%}"
ZSH_THEME_GIT_PROMPT_CLEAN=""

PROMPT_CHAR_ROOT="%{$fg_bold[red]%}➜%{$reset_color%}"
PROMPT_CHAR_USER="%{$fg[blue]%}➜%{$reset_color%}"

## show git branch/tag, or name-rev if on detached head
parse_git_branch() {
  (command git symbolic-ref -q HEAD || command git name-rev --name-only --no-undefined --always HEAD) 2>/dev/null
}

## show red star if there are uncommitted changes
parse_git_dirty() {
  if command git diff-index --quiet HEAD 2> /dev/null; then
    echo "$ZSH_THEME_GIT_PROMPT_CLEAN"
  else
    echo "$ZSH_THEME_GIT_PROMPT_DIRTY"
  fi
}

## if in a git repo, show dirty indicator + git branch
git_custom_status() {
  local git_where="$(parse_git_branch)"
  [ -n "$git_where" ] && echo " $ZSH_THEME_GIT_PROMPT_PREFIX${git_where#(refs/heads/|tags/)}$ZSH_THEME_GIT_PROMPT_SUFFIX$(parse_git_dirty)"
}

prompt_char() {
    if [ $UID -eq 0 ]; then
        echo "$PROMPT_CHAR_ROOT"
    else
        echo "$PROMPT_CHAR_USER"
    fi
}

## put fancy stuff on the right
# if which rbenv &> /dev/null; then
#   RPS1='$(git_custom_status)%{$fg[red]%}$(rbenv_version_status)%{$reset_color%} $EPS1'
# else
#   RPS1='$(git_custom_status) $EPS1'
# fi

## basic prompt on the left
# PROMPT='%{$fg[cyan]%}%~% %(?.%{$fg[green]%}.%{$fg[red]%})%B$%b '
PROMPT='%(?, ,%{$fg[red]%}✘ FAIL: $?%{$reset_color%}
)
%{$fg_bold[yellow]%}%m%{$reset_color%}: %{$fg_bold[blue]%}%~%{$reset_color%}$(git_custom_status)
%_$(prompt_char) '
