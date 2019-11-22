export TIMEFORMAT="Real: %R, User: %U, System: %S"
bind '"\C-j": "\C-atime \C-m"' # Run commands with Ctrl+J to see their execution time

nk_color_red()  { echo -e "\e[0;1;31m";      }
nk_color_green(){ echo -e "\e[0;32m";        }
nk_color_blue() { echo -e "\e[0;1;34m";        }
nk_color_nc()   { echo -e "\e[0m";           }
nk_dt()         { date '+%Y-%M-%d %H:%m:%S'; }
nk_branch_color() {
    [[ -n $(git status --porcelain=v2 2>/dev/null) ]] && echo -e "$(nk_color_red)" || echo -e "$(nk_color_green)"
}
nk_clock(){
    while sleep 1;do
        tput sc; tput cup 0 $(($( tput cols )-30))
        echo -e "$(nk_color_red)`nk_dt` $(nk_color_nc)"
        tput rc
    done &
}

nk_git_ps1()    { 
    #__git_ps1 2>/dev/null;
    git branch --no-color 2>/dev/null | grep -e ^*
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="$(nk_color_red)remote/ssh$(nk_color_nc) "
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE="$(nk_color_red)remote/ssh$(nk_color_nc) ";;
  esac
fi

PS1='\n$(nk_color_green)┌$(nk_color_nc)[$(nk_dt)] $(nk_color_green)\u $SESSION_TYPE$(nk_color_nc)@ $(nk_color_blue)\h \w$(nk_color_nc) $(nk_branch_color)$(nk_git_ps1)\n$(nk_color_green)└▶\$$(nk_color_nc)'
