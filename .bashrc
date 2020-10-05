export TIMEFORMAT="Real: %R, User: %U, System: %S"
bind '"\C-j": "\C-atime \C-m"' # Run commands with Ctrl+J to see their execution time

nk_color_red()  { echo -e "\e[0;1;31m";      }
nk_color_green(){ echo -e "\e[0;32m";        }
nk_color_blue() { echo -e "\e[0;1;34m";      }
nk_color_nc()   { echo -e "\e[0m";           }
nk_dt()         { date '+%Y-%M-%d %H:%m:%S'; }
nk_dt_dir()     { date '+%Y-%M-%d-%H-%m-%S'; }
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

# \/ \/ \/ Just ane example backup drive that should be mounted
nk_bu_drive="471ce8b8-37c2-4c61-a83c-ad3481d74023" 
nk_bu_source='/'
nk_bu_destnt="/media/$USER/$nk_bu_drive/bu_rsync"

nk_bu_create(){
    [ -d $nk_bu_destnt ] || sudo mkdir $nk_bu_destnt
    sudo rsync -aAXv $nk_bu_source --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} $nk_bu_destnt
}
nk_bu_restore(){
#    Dangerous. Commented. Uncomment if needed
#    sudo rsync -aAXv $nk_bu_destnt --exclude={"/dev/*","/proc/*","/sys/*","/tmp/*","/run/*","/mnt/*","/media/*","/lost+found"} $nk_bu_source
     echo "Done $(nk_dt)"
}

##
## Moon phase script from -> https://smithje.github.io/bash/2013/07/08/moon-phase-prompt
##

nk_get_phase_day () {
  local lp=2551443
  local now=$(date -u +"%s")
  local newmoon=592500
  local phase=$((($now - $newmoon) % $lp))
  echo $(((phase / 86400) + 1))
}

nk_get_moon_icon () {
  local phase_number=$(nk_get_phase_day)
  # Multiply by 100000 so we can do integer comparison.  Go Bash!
  local phase_number_biggened=$((phase_number * 100000))

  if   [ $phase_number_biggened -lt 184566 ];  then phase_icon="🌑"  # new
  elif [ $phase_number_biggened -lt 553699 ];  then phase_icon="🌒"  # waxing crescent
  elif [ $phase_number_biggened -lt 922831 ];  then phase_icon="🌓"  # first quarter
  elif [ $phase_number_biggened -lt 1291963 ]; then phase_icon="🌔"  # waxing gibbous
  elif [ $phase_number_biggened -lt 1661096 ]; then phase_icon="🌕"  # full
  elif [ $phase_number_biggened -lt 2030228 ]; then phase_icon="🌖"  # waning gibbous
  elif [ $phase_number_biggened -lt 2399361 ]; then phase_icon="🌗"  # last quarter
  elif [ $phase_number_biggened -lt 2768493 ]; then phase_icon="🌘"  # waning crescent
  else                                     phase_icon="🌑"  # new
  fi
  echo $phase_icon

}

nk_load_current () {
    echo "($(uptime | awk '{print $(NF-2)}' | head --bytes -2)/$(nproc)) * 100" | tr ',' '.' | bc -l | head --bytes 6
}

nk_cast_screen () {
    ffmpeg -r 15 -f x11grab -s 1920x1080 -i :0.0 -c:v libx264    -pix_fmt yuv420p -preset veryfast -tune zerolatency -bsf:v h264_mp4toannexb -b:v 5000k -bufsize 500k -f mpegts udp://127.0.0.1:8888
    echo "Cast to udp://127.0.0.1:8888"
    echo ""
}

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE="$(nk_color_red)remote/ssh$(nk_color_nc) "
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE="$(nk_color_red)remote/ssh$(nk_color_nc) ";;
  esac
fi

PS1='\n\
$(nk_color_red)\$ \
$(nk_color_nc)[$(nk_dt)] \
$(nk_color_green)\u $SESSION_TYPE$(nk_color_nc)\
$(nk_get_moon_icon) \
$(nk_color_blue)[$(nk_load_current)%] \
\h \w$(nk_color_nc) \
$(nk_branch_color)\
$(nk_git_ps1)\
$(nk_color_nc)\n\r\r\r\r\r\r\r\r\r\r\r'
