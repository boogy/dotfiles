#!/usr/bin/env bash
#
# Git shortcuts
#

alias gcl='git clone'
alias ga='git add'
alias gall='git add -A'
alias gf='git fetch --all --prune --verbose'
alias gft='git fetch --all --prune --tags --verbose'
alias gus='git reset HEAD'
alias gm="git merge"
alias g='git'
alias get='git'
alias gst='git status'
alias gs='git status'
alias gss='git status -s'
alias gsu='git submodule update --init --recursive'
alias gl='git pull'
alias gpr='git pull --rebase'
alias gpp='git pull && git push'
alias gup='git fetch && git rebase'
alias gp='git push'
alias gpo='git push origin'
alias gpu='git push --set-upstream'
alias gpom='git push origin master'
alias gdv='git diff -w "$@" | vim -R -'
alias gc='git commit -v'
alias gca='git commit -v -a'
alias gcm='git commit -v -m'
alias gci='git commit --interactive'
alias gb='git branch'
alias gba='git branch -a'
alias gbt='git branch --track'
alias gcount='git shortlog -sn'
alias gcp='git cherry-pick'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gct='git checkout --track'
alias gexport='git archive --format zip --output'
alias gdel='git branch -D'
alias gmu='git fetch origin -v; git fetch upstream -v; git merge upstream/master'
alias gll='git log --graph --pretty=oneline --abbrev-commit'
alias gg="git log --graph --pretty=format:'%C(bold)%h%Creset%C(yellow)%d%Creset %s %C(yellow)%an %C(cyan)%cr%Creset' --abbrev-commit --date=relative"
alias ggs="gg --stat"
alias gsl="git shortlog -sn"
alias gw="git whatchanged"
alias gt="git tag"
alias gta="git tag -a"
alias gtd="git tag -d"
alias gtl="git tag -l"
# From http://blogs.atlassian.com/2014/10/advanced-git-aliases/
# Show commits since last pull
alias gnew="git log HEAD@{1}..HEAD@{0}"
# Add uncommitted and unstaged changes to the last commit
alias gcaa="git commit -a --amend -C HEAD"

case $OSTYPE in
    darwin*)
        alias gtls="git tag -l | gsort -V"
        ;;
    *)
        alias gtls='git tag -l | sort -V'
        ;;
esac

if [ -z "$EDITOR" ]; then
    case $OSTYPE in
        linux*)
            alias gd='git diff | vim -R -'
            ;;
        darwin*)
            alias gd='git diff | mate'
            ;;
        *)
            alias gd='git diff'
            ;;
    esac
else
    alias gd="git diff | $EDITOR"
fi

# git helper functions
function git-branch-name
{
    git symbolic-ref HEAD 2>/dev/null | cut -d"/" -f 3
}

function git-branch-prompt
{
    local branch=`git-branch-name`
    if [ $branch ]; then printf " [%s]" $branch; fi
}

function commit
{
    if [[ ! -z $1 ]]; then
        git add . && git commit -a -m "${1}" && git push
    else
        echo "Usage: $0 MESSAGE"
    fi
}

function clone-branch
{
    URL="url.git"
    if [[ ! -z $1 ]]; then
        git clone -b $1 $URL
    else
        echo "Usage: $0 branch_name"
    fi
}

function push-to-brach
{
    if [[ ! -z $1 ]]; then
        git push -u origin $1
    else
        echo "Usage: $0 branch_name"
    fi
}

function checkout-brach
{
    if [[ ! -z $1 ]]; then
        git checkout --track -b $1 origin/$1
    else
        echo "Usage: $0 branch_name"
    fi
}

function git-remote
{ # adds remote $GIT_HOSTING:$1 to current repo
    echo "Running: git remote add origin ${GIT_HOSTING}:$1.git"
    git remote add origin $GIT_HOSTING:$1.git
}

function git-revert
{
    # applies changes to HEAD that revert all changes after this commit
    git reset $1
    git reset --soft HEAD@{1}
    git commit -m "Revert to ${1}"
    git reset --hard
}

function git_remove_missing_files
{ # git rm's missing files
    git ls-files -d -z | xargs -0 git update-index --remove
}

# Adds files to git's exclude file (same as .gitignore)
function local-ignore
{
    # adds file or path to git exclude file
    # param 1: file or path fragment to ignore
    echo "$1" >> .git/info/exclude
}

# get a quick overview for your git repo
function git_info
{
    # overview for your git repo
    if [ -n "$(git symbolic-ref HEAD 2> /dev/null)" ]; then
        # print informations
        echo "git repo overview"
        echo "-----------------"
        echo

        # print all remotes and thier details
        for remote in $(git remote show); do
            echo $remote:
            git remote show $remote
            echo
        done

        # print status of working repo
        echo "status:"
        if [ -n "$(git status -s 2> /dev/null)" ]; then
            git status -s
        else
            echo "working directory is clean"
        fi

        # print at least 5 last log entries
        echo
        echo "log:"
        git log -5 --oneline
        echo

    else
        echo "you're currently not in a git repository"
    fi
}
