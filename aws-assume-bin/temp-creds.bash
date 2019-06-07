#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parse-options.bash"
source "${DIR}/.methods.bash"

#print help
help(){
    {
        echo "USAGE: temp-creds <file> [options] "; \
            echo "DESCRIPTION: "; \
            echo "      Output temporary credentials from a specific profile into a text file like a .env. "; \
            echo "      This will work with an existing file and will overwrite the items it creates (if run more than one time)."; \
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

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"


if [ "help" == "${POSITIONAL}" ]; then
    help;
    exit 0;
fi

if [ -z "${AWS_DEFAULT_PROFILE}" ]; then
    error "--profile is required"
    echo ""
    echo ""
    help;
    exit 1;
fi


ROLE_ARN=$(aws --profile ${AWS_DEFAULT_PROFILE} configure get role_arn)
SESSION_NAME=$(whoami)
MAX_DURATION=3600
DOTENV_FILE=$POSITIONAL

if [ -z "${DOTENV_FILE}" ]; then
    error "file is required"
    echo ""
    echo ""
    help;
    exit 1;
fi

if [ -z "${ROLE_ARN}" ]; then
    error "Role arn was not found. Using wrong profile? Is this profile configured correctly? Profile: ${AWS_DEFAULT_PROFILE}"
    echo ""
    echo ""
    help;
    exit 1;
fi

debug "Role arn: ${ROLE_ARN}"

OUTPUT=$(aws --profile $AWS_DEFAULT_PROFILE sts assume-role --duration-seconds $MAX_DURATION --role-arn $ROLE_ARN --role-session-name $SESSION_NAME)
debug "Result: ${OUTPUT}"

AWS_ACCESS_KEY_ID=$(echo $OUTPUT | jq -r '.Credentials.AccessKeyId')
AWS_SECRET_ACCESS_KEY=$(echo $OUTPUT | jq -r '.Credentials.SecretAccessKey')
AWS_SESSION_TOKEN=$(echo $OUTPUT | jq -r '.Credentials.SessionToken')
EXPIRATION=$(echo $OUTPUT | jq -r '.Credentials.Expiration')

DOTENV=""

if [ -e "${DOTENV_FILE}" ]; then
    DOTENV=$(sed 's/^EXPIRATION.*//;s/^AWS_ACCESS_KEY_ID.*//;s/^AWS_SECRET_ACCESS_KEY.*//;s/^AWS_SESSION_TOKEN.*//' .env | sed '/^$/d')
fi

APPEND=$(
    echo ""
    echo ""
    echo "AWS_ACCESS_KEY_ID=${AWS_ACCESS_KEY_ID}"; \
    echo "AWS_SECRET_ACCESS_KEY=${AWS_SECRET_ACCESS_KEY}"; \
    echo "AWS_SESSION_TOKEN=${AWS_SESSION_TOKEN}"; \
    echo "EXPIRATION=${EXPIRATION}"
);

echo "$DOTENV$APPEND" > $DOTENV_FILE
