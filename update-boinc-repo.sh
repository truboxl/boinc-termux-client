#!/bin/bash
set -e
if [ ! -d ./boinc*/ ]; then
  echo "Cloning repo"; git clone https://github.com/boinc/boinc
fi
echo "Entering repo"; cd ./boinc*/
echo "git fetch"; git fetch
echo "git reset"; git reset --hard origin/master
#echo "git clean"; git clean -fxdq
echo "git apply"
git apply ../boinc-termux-patches.patch
git apply ../boinc-termux-patches-app_start-api23.patch
echo "Done"
