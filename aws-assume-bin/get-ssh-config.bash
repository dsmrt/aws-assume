#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parse-options.bash"
source "${DIR}/.text-decoration.bash"

#print help
help(){
    {
        echo "USAGE: get-ssh-config <username> [options] "; \
            echo "DESCRIPTION:"
            echo "      Get the current ssh key for the specified user and return the ssh configuation as needed for the ~/.ssh/config."; \
            echo "      This also outputs an example clone command."; \
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

USERNAME=${POSITIONAL[0]};

if [ -z "${USERNAME}" ]; then
    error "username is required"
    echo ""
    echo ""
    help;
    exit 1;
fi

if [ -z "${AWS_DEFAULT_PROFILE}" ]; then
    error "--profile is required"
    echo ""
    echo ""
    help;
    exit 1;
fi

if [ -z "${AWS_DEFAULT_REGION}" ]; then
    error "--region is required"
    echo ""
    echo ""
    help;
    exit 1;
fi

debug "${USERNAME}"
debug "${AWS_DEFAULT_PROFILE}"

FIRST_ACTIVE_KEY=$(aws --profile $AWS_DEFAULT_PROFILE iam list-ssh-public-keys --user-name ${USERNAME} | jq 'first(.SSHPublicKeys[] | select(.Status == "Active"))');

debug "$FIRST_ACTIVE_KEY"

KEY_ID=$(echo "$FIRST_ACTIVE_KEY" | jq -r '.SSHPublicKeyId')

debug $KEY_ID

ALTERED_HOST=${AWS_DEFAULT_PROFILE}-git-codecommit.amazonaws.com

read -r -d '' SSH_CONFIG << EOM
    Host ${ALTERED_HOST}
        HostName git-codecommit.${AWS_DEFAULT_REGION}.amazonaws.com
        User ${KEY_ID}
        # Private key path. Match below to the public key
        IdentityFile ~/.ssh/id_rsa
EOM

echo "Place the following in your ~/.ssh/config"
echo ""
echo "${FG_GREEN}"

echo "$SSH_CONFIG"
echo "${RESET}"

echo "Here is an example git clone:"
echo "${FG_GREEN}"
echo "git clone ssh://${ALTERED_HOST}/v1/repos/<repo_name>"
echo "${RESET}"
