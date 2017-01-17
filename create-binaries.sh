#!/bin/bash

lldb_srcdir=$1
version=$2

if [ "$lldb_srcdir" == "" -o "$version" == "" ]; then
	echo "Usage: create-binaries.sh <llvm source dir> <version>"
	exit 1
fi

if [ `uname` != "Darwin" ]; then
   echo "This script only works on osx."
   exit 1
fi

build_root=`xcodebuild -showBuildSettings -workspace $lldb_srcdir/lldb.xcworkspace -scheme lldb-tool | grep BUILD_ROOT | cut -d '=' -f 2`
if [ "$build_root" == "" ]; then
	echo "Unable to determine build dir."
	exit 1
fi

sdk_dir=$HOME/Library/Android/sdk
lldb_android_dir=$sdk_dir/lldb/2.2/android
if [ ! -d $lldb_android_dir ]; then
	echo "Unable to find directory '$lldb_android_dir'."
	echo "Make sure you have Android Studio installed."
	exit 1
fi

target=$PWD/lldb-mono-$version

echo "LLDB build dir: $build_root"

rm -rf $target
mkdir -p $target

# Copy lldb binaries
cp -r $build_root/Release/* $target

# Copy debugserver binaries
cp -r $lldb_android_dir $target/

# Copy other files
cp xa-lldb README.md $target/

# Delete files we don't need
rm $target/liblldb-core.a $target/lldb-argdumper $target/lldb-server $target/lldb-argdumper.dSYM $target/debugserver.dSYM
rm -rf $target/LLDB.framework/Resources/lldb-server
rm -rf $target/LLDB.framework/Versions/{Current,A}

du -sk $target

tar cvzf lldb-mono-$version.tar.gz lldb-mono-$version

echo "Result file: lldb-mono-$version.tar.gz."
