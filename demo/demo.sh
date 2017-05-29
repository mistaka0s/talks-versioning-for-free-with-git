#!/bin/bash

function gitdescribe() {
	desc "Running git describe --tags"
	run "git describe --tags"
}


function gitlog() {
  desc "Checking git log"
  run "git  --no-pager log -n 5 --oneline"
}


function addcommit() {
  desc "Commit $1"
  run "echo $1 > README.md; git add . ; git commit -m 'Commit $1' -q"

}

# addmanycommits <starting offset> <iterations>
function addmanycommits() {
  start=$1
  end=`expr $2 + $1`
  for i in $(seq $start $end);
  do
    echo $i > README.md; git add . ; git commit -m "Commit $i" -q
  done


}
. $(dirname ${BASH_SOURCE})/util.sh

desc "Initialising demo git repository"
run "git init -q"
run "git status --short"

addcommit 0
gitdescribe
gitlog

desc "Let's tag the inital commit"
run "git tag 1.0.0"

gitdescribe
addcommit 1

gitdescribe

addcommit 2
gitdescribe
gitlog

desc "Note that we've got a unique version everytime we've commited"
desc "Let's add 1000 more commits"

addmanycommits 3 1000
gitdescribe
gitlog

desc "Tagging the next version"
run "git tag 1.1.0"

gitdescribe
gitlog


desc "One final commit"
addcommit 1004

gitdescribe
gitlog
