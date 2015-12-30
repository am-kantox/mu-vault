#!/bin/bash

TODAY=` date +"%Y%m%d"`
if [[ -d $TODAY ]]
then
  echo "The today data is already loaded. Please remove directory $TODAY and rerun this script."
else
  mkdir $TODAY
  cd $TODAY
  wget -r --no-parent https://www.vaultproject.io/docs/http/index.html
  mv www.vaultproject.io/docs/http/sys*html .
  rm -rf www.vaultproject.io
fi
