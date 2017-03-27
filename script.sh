#!/bin/sh

setup_git() {
  git config --global user.email "travis@travis-ci.org"
  git config --global user.name "Travis CI"
}

commit_website_files() {
  git checkout -b
  git add -A
  git commit --message "Travis build #{Time.now.utc}"
}

upload_files() {
  git remote add origin https://${GH_TOKEN}@github.com/dphilippon/dphilippon.github.io.git
  git push --quiet --set-upstream origin-pages gh-pages 
}

setup_git
commit_website_files
upload_files