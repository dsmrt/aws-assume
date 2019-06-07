#!/bin/bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parse-options.bash"

# Use managed policy
CODECOMMIT_POLICY_ARN=arn:aws:iam::aws:policy/AWSCodeCommitPowerUser

#print help
help(){
    {
        echo "USAGE: cp-public-key <username> <from-aws-profile> <to-aws-profile> [options] "; \
            echo "DESCRIPTION: "; \
            echo "      Copy CodeCommit public key from one account to the other. This command will create a user if needed, assign the "; \
            echo "      AWSCodeCommitPowerUser managed role, and upload the public key from one account (specified profile) to an other (specified profile)."; \
            echo "OPTIONS:"; \
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
FROM_PROFILE=${POSITIONAL[1]};
TO_PROFILE=${POSITIONAL[2]};

if [ "help" == "${USERNAME}" ]; then
    help;
    exit 0;
fi

if [ -z "${USERNAME}" ]; then
    error "username is required"
    echo ""
    echo ""
    help;
    exit 1;
fi

if [ -z "${FROM_PROFILE}" ]; then
    error "from-aws-profile is required"
    echo ""
    echo ""
    help;
    exit 1;
fi

if [ -z "${TO_PROFILE}" ]; then
    error "to-aws-profile is required"
    echo ""
    echo ""
    help;
    exit 1;
fi

KEYID=$(aws --profile ${FROM_PROFILE} iam list-ssh-public-keys --user-name $USERNAME | jq -r '.SSHPublicKeys[] | limit(1; select(.Status == "Active")) | .SSHPublicKeyId');
debug "Found key: $KEYID"

if [ -z "${KEYID}" ]; then
    error "No key found in FROM profile."

    exit 1;
fi

PUBLIC_KEY=$(aws --profile ${FROM_PROFILE} iam get-ssh-public-key --user-name $USERNAME --ssh-public-key-id $KEYID --encoding PEM | jq -r '.SSHPublicKey.SSHPublicKeyBody')

debug "$PUBLIC_KEY"
debug "Found public key ... going to save it to the new profile: ${TO_PROFILE}"

debug "User ${USERNAME} already exist in account (profile: ${TO_PROFILE})? "

TO_USER=$(aws --profile ${TO_PROFILE} iam get-user --user-name ${USERNAME});

if [ -z "${TO_USER}" ]; then
    aws --profile ${TO_PROFILE} iam create-user --user-name ${USERNAME}
fi

debug "Adding codecommit policy to user"
aws --profile ${TO_PROFILE} iam attach-user-policy --user-name ${USERNAME} --policy-arn ${CODECOMMIT_POLICY_ARN}

debug "Uploading ssh key to user"
aws --profile ${TO_PROFILE} iam upload-ssh-public-key --user-name ${USERNAME} --ssh-public-key-body "${PUBLIC_KEY}"

