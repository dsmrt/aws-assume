#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "${DIR}/.parse-options.bash"

# Use managed policy
CODECOMMIT_POLICY_ARN=arn:aws:iam::aws:policy/AWSCodeCommitPowerUser

#print help
help(){
    {
        echo "USAGE: upload-public-key <username> <path-to-public-key> [options] "; \
            echo "DESCRIPTION: "; \
            echo "      Uploads an public ssh key to your aws user."; \
            echo "OPTIONS:"; \
            echo "      -p --profile"; \
            echo "              AWS profile name to authenticate with"; \
            echo "      -r --region"; \
            echo "              AWS region where the codecommit repo lives"; \
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
PATH_TO_PUBLIC_KEY=${POSITIONAL[1]:-"~/.ssh/id_rsa.pub"};
PRIVATE_KEY=$(echo ${PATH_TO_PUBLIC_KEY} | sed 's/\.pub//;')
AWS_ASSUME="${DIR}/../aws-assume"

if [ "help" == "${USERNAME}" ]; then
    help;
fi

if [ -z "${USERNAME}" ]; then
    error "username is required"
    echo ""
    echo ""
    help 1;
fi

if [ -z "${PATH_TO_PUBLIC_KEY}" ]; then
    error "path to public key is required"
    echo ""
    echo ""
    help 1;
fi

debug "Checking to see if there is already a iam user for ${USERNAME}"
TO_USER=$(aws --profile ${AWS_DEFAULT_PROFILE} iam get-user --user-name ${USERNAME});

if [ -z "${TO_USER}" ]; then
    debug "User doesn't exist, creating user: ${USERNAME}"
    aws --profile ${AWS_DEFAULT_PROFILE} iam create-user --user-name ${USERNAME}
fi

aws --profile ${AWS_DEFAULT_PROFILE} iam upload-ssh-public-key \
    --user-name ${USERNAME} --ssh-public-key-body "$(cat ${PATH_TO_PUBLIC_KEY})"

if [ -z "${AWS_DEFAULT_REGION}" ]; then
    AWS_DEFAULT_REGION='us-east-1'
fi
debug "Aws region ${AWS_DEFAULT_REGION}"
${AWS_ASSUME} get-ssh-config ${USERNAME} "${PRIVATE_KEY}" --profile ${AWS_DEFAULT_PROFILE} --region ${AWS_DEFAULT_REGION}

