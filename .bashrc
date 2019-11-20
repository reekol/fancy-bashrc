
export TIMEFORMAT="Real: %R, User: %U, System: %S"
bind '"\C-j": "\C-atime \C-m"' # Run any commands with Ctrl+J to see their execution time
acolor() {
    [[ -n $(git status --porcelain=v2 2>/dev/null) ]] && echo 31 || echo 32
}
PS1='\[\033[0m\033[0;32m\]┌\[\033[0m\][$(date +%T)] \[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;$(acolor)m\]$(__git_ps1)\n\[\033[0;32m\]└\[\033[0m\033[0;32m\]▶\[\033[0m\] '
#while sleep 1;do tput sc;tput cup 0 1;echo -e "\e[31m`date +%T`\e[39m";tput rc;done &
