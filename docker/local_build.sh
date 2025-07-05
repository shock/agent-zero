#!/bin/bash

## get branch name from first argument
BRANCH=$1
if [ -z "$BRANCH" ]; then
    BRANCH="development"
fi

ORIGIN="$(git remote get-url origin)"
if [ -z "$ORIGIN" ]; then
    ORIGIN="git@github.com:frdel/agent-zero.git"
fi

[[ $ORIGIN != https://* ]] && HTTPS_URL=$(echo "$ORIGIN" | sed -E 's#git@github.com:(.*)/(.*).git#https://github.com/\1/\2.git#') || HTTPS_URL=$ORIGIN

echo "Branch: $BRANCH"
echo "Origin: $ORIGIN"

cd $(dirname $0)
cd base
docker build -t agent-zero-base:local --build-arg CACHE_DATE=$(date +%Y-%m-%d:%H:%M:%S)  .
# docker build -t agent-zero-base:local --no-cache  .

cd ../run
docker build -f Dockerfile.local -t agent-zero-run:local --build-arg BRANCH=$BRANCH --build-arg ORIGIN=$HTTPS_URL --build-arg CACHE_DATE=$(date +%Y-%m-%d:%H:%M:%S)  .
