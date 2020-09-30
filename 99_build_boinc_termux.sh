#!/data/data/com.termux/files/usr/bin/sh
set -e

export OUTPUT_FOLDER_BIN="${HOME}/bin"
echo "OUTPUT_FOLDER_BIN=${OUTPUT_FOLDER_BIN}"

echo "PREFIX=${PREFIX}"
if [ ! -d "$PREFIX" ]; then
  echo '$PREFIX is currently invalid. Build script may fail'
fi

echo "===== BOINC build for Termux start ====="

# please clone BOINC repo or get a release source first
cd ./boinc*/

export BOINC="$PWD"

if [ -e ./Makefile ] && grep -q '^distclean:' ./Makefile; then
  make distclean -s
fi

# Unfortunately BOINC ./configure is not intelligent in setting FLAGS for Android
# -flto require llvm or gcc variant of ar and ranlib
# -flto does not support -Os
export AR='llvm-ar'
export RANLIB='llvm-ranlib'
export OBJDUMP='llvm-objdump'
export NM='llvm-nm'
export CFLAGS="${CFLAGS} -O2 -mcpu=native -fstack-protector-strong -ffixed-x18"
export CXXFLAGS="${CXXFLAGS} ${CFLAGS}"
export LDFLAGS='-landroid-shmem'

./_autosetup
./configure -C \
  --disable-server \
  --disable-manager \
  --prefix="$PREFIX" \
  --host="$(uname -m)-linux-android" \
  --enable-bitness=64 \
  #--with-boinc-platform=aarch64-android-linux-gnu \
  #--with-boinc-alt-platform=

chrt -i 0 make -s -j6

# we are not going to install
# you can still "make install" if you want
# please check README.md to uninstall properly
make -s install DESTDIR=${BOINC}/stage

echo 'Stripping binaries'
cd "${BOINC}/stage${PREFIX}/bin/"
strip ./*
du ./*

while true; do
  echo "Checking whether BOINC is running... $(pidof boinc)"
  if [ -z "$(pidof -s boinc)" ]; then break; fi
  echo 'Killing BOINC...'
  kill "$(pidof -s boinc)"
  sleep 15
done

echo 'Copying binaries'
mkdir -p "$OUTPUT_FOLDER_BIN"
cp -frv ./* "$OUTPUT_FOLDER_BIN/"

echo "===== BOINC build for Termux done ====="

for i in "start-boinc"; do
  if [ -n "$(which $i)" ]; then
    while [ -n "$(pidof -s $i)" ]; do
      kill "$(pidof -s $i)"
      sleep 5
    done
    echo 'Starting BOINC'
    $i &
  fi
done
