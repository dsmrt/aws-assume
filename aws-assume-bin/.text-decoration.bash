#0    black     COLOR_BLACK     0,0,0
#1    red       COLOR_RED       1,0,0
#2    green     COLOR_GREEN     0,1,0
#3    yellow    COLOR_YELLOW    1,1,0
#4    blue      COLOR_BLUE      0,0,1
#5    magenta   COLOR_MAGENTA   1,0,1
#6    cyan      COLOR_CYAN      0,1,1
#7    white     COLOR_WHITE     1,1,1

if [ -n "$TERM" ]; then
    FG_BLACK=`tput setaf 0`
    FG_RED=`tput setaf 1`
    FG_GREEN=`tput setaf 2`
    FG_YELLOW=`tput setaf 3`
    FG_BLUE=`tput setaf 4`
    FG_MAGENTA=`tput setaf 5`
    FG_CYAN=`tput setaf 6`
    FG_WHITE=`tput setaf 7`

    RESET=`tput sgr0`
    BOLD=`tput bold`
fi

