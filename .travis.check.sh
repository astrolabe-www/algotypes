#!/bin/bash

set -e

CHANGED_FILES=`git diff --name-only master...${TRAVIS_COMMIT}`
DEPLOY=False
PAT="algotypes_bot"

for CHANGED_FILE in $CHANGED_FILES; do
  if [[ $CHANGED_FILE =~ $PAT ]]; then
    DEPLOY=True
    break
  fi
done

if [[ $DEPLOY == False ]]; then
  echo "Don't deploy"
  travis_terminate 0
  exit 1
else
  echo "Deploy"
fi
