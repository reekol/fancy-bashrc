export TIMEFORMAT="Real: %R, User: %U, System: %S $nk_start"
bind '"\C-j": "\C-atime \C-m"' # Run commands with Ctrl+J to see their execution time

nk_branch_color() {
    [[ -n $(git status --porcelain=v2 2>/dev/null) ]] && echo 31 || echo 32
}
nk_dt(){
    date '+%Y-%M-%d %H:%m:%S'
}
nk_clock(){
    while sleep 1;do
        tput sc; tput cup 0 $(($( tput cols )-30))
        echo -e "\e[31m\e[1m \U1f551 `nk_dt` \e[39m"
        tput rc
    done &
}

PS1='\n\[\033[0m\033[0;32m\]┌\[\033[0m\][$(nk_dt)] \[\033[0;32m\]\[\033[0m\033[0;32m\]\u\[\033[0;36m\] @ \[\033[0;36m\]\h \w\[\033[0;$(nk_branch_color)m\]$(__git_ps1)\n\[\033[0;32m\]└\[\033[0m\033[0;32m\]▶\[\033[0m\] '
