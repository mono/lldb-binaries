#!/bin/bash

lldb_srcdir=$1

if [ "$lldb_srcdir" == "" ]; then
	echo "Usage: create-binaries.sh <llvm source dir>"
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

echo "LLDB build dir: $build_root"
echo "Target dir: $PWD/Release"

cp -r $build_root/Release .

# Delete files we don't need
rm Release/liblldb-core.a
rm -rf Release/lldb-argdumper Release/lldb-server Release/lldb-argdumper.dSYM Release/debugserver.dSYM
rm -rf Release/LLDB.framework/Resources/lldb-server
rm -rf Release/LLDB.framework/Versions/{Current,A}

du -sk Release
