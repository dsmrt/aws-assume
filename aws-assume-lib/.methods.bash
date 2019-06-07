#!/usr/bin/env bash

source "${DIR}/.text-decoration.bash"

contains() {
    local n=$#
    local value=${!n}
    for ((i=1;i < $#;i++)) {
        if [ "${!i}" == "${value}" ]; then
            echo "YES"
            return 0
        fi
    }
    echo "NO"
    return 1
}

debug(){
    if [ "$DEBUG" == "YES" ]; then
        printf "${FG_YELLOW}%s [debug] %s \n${RESET}" "`date +'%Y-%m-%d %H:%M:%S'`" "$1"
    fi
}

error(){
    printf "${FG_RED}%s [error] %s \n${RESET}" "`date +'%Y-%m-%d %H:%M:%S'`" "$1"
}
