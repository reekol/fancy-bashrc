nk_branch_color() {
    [[ -n $(git status --porcelain=v2 2>/dev/null) ]] && echo 31 || echo 32
}
nk_clock(){
    local cols=0
    while sleep 1;do
        cols=$( tput cols )
        lines=$(tput lines)
        tput sc
        tput cup 0 $(($cols-30))
        echo -e "\e[31m\e[1m \U1f551 `date '+%Y-%M-%d %H:%m:%S'` \e[39m"
        tput rc
    done &
}

PS1='\n\[\033[0m\033[0;32m\]┌\[\033[0m\][$(date +%T)] \[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;$(nk_branch_color)m\]$(__git_ps1)\n\[\033[0;32m\]└\[\033[0m\033[0;32m\]▶\[\033[0m\] '
