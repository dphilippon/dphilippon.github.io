#!/bin/sh

setup_git() {
  echo "Setting up GIT"
  git config --global user.email "hqnghi88@gmail.com"
  git config --global user.name "hqnghi88"
  git config --global push.default matching
  ls wiki
}

commit_website_files() {
  echo "Commiting GIT"
  git status 
  echo "add -A"
  
  git add -A
  echo "commit "
  
  git commit --message "Travis build #{Time.now.utc}"
  echo ${GH_TOKEN}
}

upload_files() {
  echo "Uploading GIT"
  #git remote add origin https://${GH_TOKEN}@github.com/dphilippon/dphilippon.github.io.git
  git push -f https://hqnghi88:$HQN_KEY@github.com/dphilippon/dphilippon.github.io.git
  #git push --quiet --set-upstream origin master
}

setup_git
commit_website_files
#upload_files
