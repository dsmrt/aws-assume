#!/usr/bin/env bash
set -eu

INSTALL_LOCATION=/usr/local/bin
EXECUTABLE=aws-assume
LIB=aws-assume-lib
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -e "${INSTALL_LOCATION}/${EXECUTABLE}" ]; then
    echo "Deleting old executable"
    rm -v ${INSTALL_LOCATION}/${EXECUTABLE}
    rm -rv ${INSTALL_LOCATION}/${LIB}
fi


cp -vr ${DIR}/${EXECUTABLE} ${DIR}/${LIB} $INSTALL_LOCATION || \
    (echo "Issue with copy." && exit 1)

chmod +x ${INSTALL_LOCATION}/${EXECUTABLE} || \
    (echo "Issue with chmod on ${INSTALL_LOCATION}/${EXECUTABLE}."; exit 1)

echo "Testing executable"
aws-assume -v
