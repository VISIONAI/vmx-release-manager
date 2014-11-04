#!/bin/bash
#
# A script to make symlinks to for the latest and the stable version
# of packages (either .tar.gz or .pkg) inside a builds directory. Uses
# "Mac" or "Linux" or "." for either Mac builds, Linux builds, and
# platform-independent builds.
#
# This script assumes you have your files at
# $ROOTDIR/$NAME/$PLATFORM/, which in the case of VMX is something
# like: /www/vmx/VMXserver/Linux/
#
# 1. This script will generate symliks for the "latest" version as well
# as the "stable" version, where "latest" has the most recent
# timestamp and "stable" has no dashses in the filename.  This works
# when git tagging with stable version numbers like v0.1.2 and using
# `git describe --tags --dirty` for the build version.
#
# 2. This script will generate a size+MD5hash+filename listing for the
# latest build by appending .files.txt to the latest build name. This
# only works for .tar.gz.  If you know how to use xar on Linux to
# extract the contents of a Mac .pkg file, do let me know. For
# details, see list_contents.sh
#
# 3. This script will generate MD5SUMS.txt, SHA1SUMS.txt, and
# SHA256SUMS.txt files for all tarballs inside the release directory
# (including the latest and stable) symlinks.  This is useful for
# determing which version the latest/stable builds actually point to.
# These text files can also be downloaded to verify that your
# downloaded version matches these checksums and hasn't been tampered
# with.
# 
# Copyright 2014 Tomasz Malisiewicz (tom@vision.ai)

if [ "$#" -ne 2 ]; then
    echo "Usage: $0 build_name platform"
    echo "Example: $0 VMXserver Linux"
    echo "Example: $0 vmxAppBuilder ."
    exit;
fi

ROOTDIR=/www/vmx/

NAME=$1
PLATFORM=$2

if [ "$PLATFORM" == "." ]; then
    PSTRING=""
else
    PSTRING=_${PLATFORM}
fi

echo 'Name='$NAME 'Platform='$PLATFORM
TARBALLS=`find $ROOTDIR/$NAME/$PLATFORM/ -type f -name "*.tar.gz" -o -type f -name "*.pkg"`
latest=`ls -ltr $TARBALLS | awk {'print $9'} | tail -1`
echo 'Latest is' $latest
EXT=tar.gz
if [ "`basename $latest .pkg`.pkg" == "`basename $latest`" ]; then
    EXT=pkg
fi

if [ -z "$TARBALLS" ]; then
    echo  '---- Skipping this configuration, no tarballs'
    continue
fi

echo 'EXT is' $EXT
if [ "$EXT" == "tar.gz" ]; then
    echo "listing contents of " $latest
    ./list_contents.sh $latest > ${latest}'.files.txt'
fi

rm $ROOTDIR/$NAME/$PLATFORM/${NAME}${PSTRING}.latest.${EXT} 2>/dev/null
ln -s `basename $latest` $ROOTDIR/$NAME/$PLATFORM/${NAME}${PSTRING}.latest.${EXT}

stable=`find $ROOTDIR/$NAME/$PLATFORM/ -type f -name "*.tar.gz" -o -type f -name "*.pkg" | xargs ls -ltr | awk {'print $9'} | grep -v "-" | tail -1`
echo 'Stable is ' $stable
rm $ROOTDIR/$NAME/$PLATFORM/${NAME}${PSTRING}.stable.${EXT} 2>/dev/null
ln -s `basename $stable` $ROOTDIR/$NAME/$PLATFORM/${NAME}${PSTRING}.stable.${EXT}

cd $ROOTDIR/$NAME/$PLATFORM/
md5sum *.${EXT} > MD5SUMS.txt 2>/dev/null
sha1sum *.${EXT} > SHA1SUMS.txt 2>/dev/null
sha256sum *.${EXT} > SHA256SUMS.txt 2>/dev/null
cd - >/dev/null





