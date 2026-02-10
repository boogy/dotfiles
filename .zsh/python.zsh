alias py="python"
alias py2="python2"
alias py3="python3"
alias pycmd="python -c "
alias shttp='python -m SimpleHTTPServer'
alias http_server_py3='python3 -m http.server'
alias upgrade-all-pip2="pip2 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 sudo pip2 install -U"
alias upgrade-all-pip3="pip3 freeze --local | grep -v '^\-e' | cut -d = -f 1  | xargs -n1 sudo pip3 install -U"

# pip bash completion start
_pip_completion() {
  COMPREPLY=($(COMP_WORDS="${COMP_WORDS[*]}" \
    COMP_CWORD=$COMP_CWORD \
    PIP_AUTO_COMPLETE=1 $1))
}
complete -o default -F _pip_completion pip
complete -o default -F _pip_completion pip3
# pip bash completion end

function pyedit() {
  # opens python module in your EDITOR
  # param 1: python module to open
  # example '$ pyedit requests'
  xpyc=$(python -c "import sys; stdout = sys.stdout; sys.stdout = sys.stderr; import $1; stdout.write($1.__file__)")

  test ! -z $EDITOR && export EDITOR=vim

  if [ "$xpyc" == "" ]; then
    echo "Python module $1 not found"
    return -1

  elif [[ $xpyc == *__init__.py* ]]; then
    xpydir=$(dirname $xpyc)
    echo "$EDITOR $xpydir"
    $EDITOR "$xpydir"
  else
    echo "$EDITOR ${xpyc%.*}.py"
    $EDITOR "${xpyc%.*}.py"
  fi
}

export PIPENV_VENV_IN_PROJECT=1
#eval $(pipenv --completion)
