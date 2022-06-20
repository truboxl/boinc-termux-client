#!/bin/sh
set -e
export REPO="${PWD}"
if [ ! -d ./src/boinc*/ ]; then
    echo "Cloning repo"; git clone https://github.com/boinc/boinc src/boinc
fi
echo "Entering repo"; cd ./src/boinc*/
echo "git fetch"; git fetch
echo "git reset"; git reset --hard origin/master
echo "git clean"; git clean -fxdq
echo "git apply"
git apply ${REPO}/patches/boinc-termux-patches.patch
#git apply ${REPO}/patches/boinc-termux-patches-app_start-api23.patch
git apply ${REPO}/patches/boinc-domain-name.patch
echo "Done"
