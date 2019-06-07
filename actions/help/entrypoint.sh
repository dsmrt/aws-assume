#!/usr/bin/env bash

echo "No arguments"
/github/workspace/aws-assume
echo "Passing help"
/github/workspace/aws-assume help

echo "No arguments to cp-public-key"
/github/workspace/aws-assume cp-public-key
echo "Passing help to cp-public-key"
/github/workspace/aws-assume cp-public-key help

echo "No arguments to get-ssh-config"
/github/workspace/aws-assume get-ssh-config
echo "Passing help to get-ssh-config"
/github/workspace/aws-assume get-ssh-config help


echo "No arguments to temp-creds"
/github/workspace/aws-assume temp-creds
echo "Passing help to temp-creds"
/github/workspace/aws-assume temp-creds help
