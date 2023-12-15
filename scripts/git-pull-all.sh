#!/usr/bin/env bash
set -eou pipefail

dirs=$(find . -type d -name "\.git" | grep -v "cdk\.out")

for dir in ${dirs[@]}; do
	REPO_DIR=$(dirname $dir)
	echo "Pulling latest changes to $REPO_DIR ..."
	git -C "$REPO_DIR" pull
	git -C "$REPO_DIR" fetch
	git -C "$REPO_DIR" remote prune origin

	# TODO: fix me. This is the proper way of doing it but the implementation is currently broken. We want to track an upstream branch if we are not tracking, then merge from origin/$BRANCH -> $BRANCH for each out of date branch
	#git -C "$REPO_DIR" branch -r | grep -v '\->' | sed "s,\x1B\[[0-9;]*[a-zA-Z],,g" | while read remote; do git -C "$REPO_DIR" branch --track "${remote#origin/}" "$remote" || true; done
	#git -C "$REPO_DIR" fetch --all
	#git -C "$REPO_DIR" pull --all
done


