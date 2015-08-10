#!/bin/bash
# Fragmentos e parametros de Jonathan Protzenko

export PATH=/media/tmp/android-ndk-r10e/toolchains/arm-linux-androideabi-4.9/prebuilt/linux-x86_64/bin/:$PATH
export PATH=/media/tmp/android-ndk-r10e/:$PATH
export PROGRAMS="dropbear dropbearconvert scp dbclient dropbearkey"

export BINARIOS=`eval cd ../binarios;pwd`
export CC=`eval ndk-which gcc`
export CXX=`eval ndk-which g++`
export LD=`eval ndk-which ld`
export AR=`eval ndk-which ar`
export RANLIB=`eval ndk-which ranlib`
export STRIP=`eval ndk-which strip`
export ANDROID_NDK_ROOT=/media/tmp/android-ndk-r10e/
export SYSROOT=/media/tmp/android-ndk-r10e/platforms/android-14/arch-arm/
export CFLAGS=--sysroot=$SYSROOT
export CXXFLAGS=--sysroot=$SYSROOT
export CPPFLAGS=--sysroot=$SYSROOT
export LDFLAGS=--sysroot=$SYSROOT

cd ../dropbear-2013.58
patch -p1 < ../extras/dropbear-patch2

./configure --prefix=$BINARIOS --build=x86_64-unknown-linux-gnu --host=arm-linux-androideabi --disable-zlib --disable-largefile --disable-loginfunc --disable-shadow --disable-utmp --disable-utmpx --disable-wtmp --disable-wtmpx --disable-pututline --disable-pututxline --disable-lastlog

echo "#define USE_DEV_PTMX 1" >> config.h

read -p "Editar options.h com vi... Pressione enter para continuar."
vi ./options.h
read -p "Pressione enter para continuar."
STATIC=1 SCPPROGRESS=0 PROGRAMS="$PROGRAMS" make

for PROGRAM in $PROGRAMS; do
	$STRIP $PROGRAM
done

make install
cd -
