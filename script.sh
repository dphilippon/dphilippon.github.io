#!/bin/sh

setup_git() {
  echo "Setting up GIT"
  git config --global user.email "hqnghi88@gmail.com"
  git config --global user.name "hqnghi88"
}

commit_website_files() {
  echo "Commiting GIT"
  git checkout -b
  git add -A
  git commit --message "Travis build #{Time.now.utc}"
  echo ${GH_TOKEN}
}

upload_files() {
  echo "Uploading GIT"
  #git remote add origin https://${GH_TOKEN}@github.com/dphilippon/dphilippon.github.io.git
  git push -f -q https://hqnghi88:$HQN_KEY@github.com/dphilippon/dphilippon.github.io.git
  #git push --quiet --set-upstream origin master
}

setup_git
commit_website_files
upload_files
