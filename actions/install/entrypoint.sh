#!/usr/bin/env bash
set -eu

echo ""
echo ""
echo "~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~=="
echo "Testing installer"
echo "~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~=="
/github/workspace/install.sh

echo ""
echo ""
echo "~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~=="
echo "Testing installer Again! Which will remove and reinstall."
echo "~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~==~=="
/github/workspace/install.sh
