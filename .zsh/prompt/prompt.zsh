# ZSH_THEME_GIT_PROMPT_PREFIX=" %{$fg_bold[green]%}"
# ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
# ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}⚡"
# ZSH_THEME_GIT_PROMPT_CLEAN=""

# function prompt_char {
# 	if [ $UID -eq 0 ]; then echo "%{$fg_bold[red]%}#%{$reset_color%}"; else echo $; fi
# }

# PROMPT='%(?, ,%{$fg[red]%}FAIL: $?%{$reset_color%}
# )
# %{$fg_bold[yellow]%}%m%{$reset_color%}: %{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info)
# %_$(prompt_char) '


## without oh-my-zsh
function prompt_char {
	if [ $UID -eq 0 ]; then echo "%{$fg_bold[red]%}#%{$reset_color%}"; else echo $; fi
}

PROMPT='%(?, ,%{$fg[red]%}FAIL: $?%{$reset_color%}
)
%{$fg_bold[yellow]%}%m%{$reset_color%}: %{$fg_bold[blue]%}%~%{$reset_color%}$(git_prompt_info)
%_$(prompt_char) '
