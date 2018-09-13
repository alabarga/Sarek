#!/bin/bash
set -xeuo pipefail

CODENAME=''
RELEASE=''

while [[ $# -gt 0 ]]
do
  key=$1
  case $key in
    -c|--codename)
    CODENAME=$2
    shift # past argument
    shift # past value
    ;;
    -r|--release)
    RELEASE=$2
    shift # past argument
    shift # past value
    ;;
  esac
done

if [[ $CODENAME == "" ]]
then
  echo "No codename specified"
  exit
fi

if [[ $RELEASE == "" ]]
then
  echo "No release specified"
  exit
fi

echo "Preparing release $RELEASE - $CODENAME"

sed -i "s/\[Unreleased\]/[$RELEASE] - $CODENAME - $(date +'%Y-%m-%d')/g" CHANGELOG.md
sed -i "s/sarek-[0-9\.]\+/sarek-$RELEASE/g" Dockerfile
sed -i "s/sarek-[0-9\.]\+/sarek-$RELEASE/g" Singularity
sed -i "s/version = '[0-9\.]\+'/version = '$RELEASE'/g" conf/base.config

git commit CHANGELOG.md Dockerfile Singularity conf/base.config -m "preparing release $RELEASE [skip ci]"
