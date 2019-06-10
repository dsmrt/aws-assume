#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parse-options.bash"
source "${DIR}/.methods.bash"

#print help
help(){
    {
        echo "USAGE: open"; \
            echo "DESCRIPTION: "; \
            echo "      Open the AWS Console to Switch Roles of the profile specified. "; \
            echo "OPTIONS:"; \
            echo "      -p --profile"; \
            echo "              AWS profile name to authenticate with"; \
            echo "      -d --debug"; \
            echo "              Show debug messaging"; \
            echo "      -h --help"; \
            echo "              Show this message"; \
    }
    EXIT_CODE=$1

    if [ -z "$EXIT_CODE" ]; then
        EXIT_CODE=0
    fi

    exit $EXIT_CODE;
}

if [ "help" == "${POSITIONAL}" ]; then
    help;
    exit 0;
fi

if [ -z "${AWS_DEFAULT_PROFILE}" ]; then
    error "--profile is required"
    echo ""
    echo ""
    help 1;
fi


ROLE_ARN=$(aws --profile ${AWS_DEFAULT_PROFILE} configure get role_arn)
ROLE_NAME=$(echo ${ROLE_ARN} | sed -E 's#.*/([A-Za-z]+)#\1#');
USERNAME=$(whoami)
SESSION_NAME="${AWS_DEFAULT_PROFILE}%20-%20${USERNAME}:${ROLE_NAME}"
ACCOUNT_ID=$(aws sts get-caller-identity --profile ${AWS_DEFAULT_PROFILE} --output text --query 'Account'| tail -n 1)


debug "Role ARN: ${ROLE_ARN}"
debug "Role Name: ${ROLE_NAME}"
debug "Account ID: ${ACCOUNT_ID}"

URL="https://signin.aws.amazon.com/switchrole?account=${ACCOUNT_ID}&roleName=${ROLE_NAME}&displayName=${SESSION_NAME}"

debug "Switch Roles URL: ${URL}"

open ${URL}
