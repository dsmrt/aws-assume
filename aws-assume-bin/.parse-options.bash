#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.text-decoration.bash"
source "${DIR}/.methods.bash"

POSITIONAL=()
SCRIPT_NAME=`basename "$0"`

while [[ $# -gt 0 ]]
do
key="$1"

case $key in
    -h|--help)
    HELP=YES
    shift # past argument
    ;;
    -p|--profile)
    export AWS_DEFAULT_PROFILE="$2"
    shift # past argument
    shift # past value
    ;;
    -r|--region)
    export AWS_DEFAULT_REGION="$2"
    shift # past argument
    shift # past value
    ;;
    -d|--debug)
    DEBUG="YES"
    shift # past argument
    ;;
    *)    # unknown option
    POSITIONAL+=("$1") # save it in an array for later. This should be the .env file.
    shift # past argument
    ;;
esac
done
set -- "${POSITIONAL[@]}" # restore positional parameters

YES=("YES" "Y" "yes" "y")
NO=("NO" "N" "no" "n")

if [ "$HELP" == "YES" ]; then
    help 0;
fi

# if [ -z "${APP}" ]; then
#     required_options
#     exit 1;
# fi

