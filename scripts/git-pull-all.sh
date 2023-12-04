#!/usr/bin/env bash
set -eou pipefail

dirs=$(find . -type d -name "\.git" | grep -v "cdk\.out")

for dir in ${dirs[@]}; do
	REPO_DIR=$(dirname $dir)
	echo "Pulling latest changes to $REPO_DIR ..."
	git -C "$REPO_DIR" pull
done


