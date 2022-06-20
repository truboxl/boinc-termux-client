#!/bin/sh
set -e
export REPO="${PWD}"
if [ ! -d ./src/boinc*/ ]; then
	echo "git clone https://github.com/boinc/boinc src/boinc"
	git clone https://github.com/boinc/boinc src/boinc
fi

echo "cd ./src/boinc*/"
cd ./src/boinc*/

echo "git fetch"
git fetch

echo "git reset --hard origin/master"
git reset --hard origin/master

echo "git clean -fxdq"
git clean -fxdq

echo "patch -p1 -i *.patch"
for patch in ${REPO}/patches/*.patch; do
	patch -p1 -i "$patch"
done
echo "Done"
