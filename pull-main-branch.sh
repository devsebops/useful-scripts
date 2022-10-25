#! /usr/bin/env bash
# For a given directory enters all subdirectories pulling the main branch of a repository

CURRENT_DIR=$PWD

for repo in */; do
  cd $repo
  echo "$repo"
  MAIN_BRANCH=$(git remote show origin | sed -n '/HEAD branch/s/.*: //p')
  git fetch -q
  git checkout $MAIN_BRANCH
  git pull -q
  if [ $? -ne 0 ]; then
    echo $repo >>../broken-merges.txt
  fi
  git remote prune origin
  echo ""
  cd $CURRENT_DIR
done

if [ -f broken-merges.txt ]; then
  echo 'Failed to pull the following repositories'
  cat broken-merges.txt
  rm broken-merges.txt
fi
