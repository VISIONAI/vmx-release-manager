#!/bin/sh
#
# Computes the file sizes and MD5 checksums of the individual files
# inside the tarball prints them to stdout. Will use the temp
# directory /tmp/tarball_name/ so make sure nothing there is of utmost
# importance.  NOTE: This script is not parallel-safe as one process
# might be deleting file and another might be computing checksums.
#
# See example at https://files.vision.ai/vmx, all files with extension
# .tar.gz.files.txt are the output of this script.
#
# Copyright 2014 Tomasz Malisiewicz (tom@vision.ai)

# Make sure there is only one input argument
if [ "$#" -ne 1 ]; then
    echo "Usage: $0 /my/tarball_location/file.tar.gz"
    exit;
fi

# Make sure the input is a tarball (.tar.gz file)
if [ `basename $1 .tar.gz`.tar.gz != `basename $1` ]; then
    echo "$0 Cannot proceed: $1 is not a .tar.gz file"
    exit;
fi

# Make sure the file actually exists
if [ ! -f $1 ]; then
    echo "$0 Cannot proceed: $1 does not exist"
    exit;
fi

TMPDIR=`basename $1`

# Clear out temp directory, put the tarball there, extract contents,
# then delete tarball, leaving contents inside $TMPDIR intact.

rm -rf /tmp/$TMPDIR/
mkdir /tmp/$TMPDIR//
cp $1 /tmp/$TMPDIR/
cd /tmp/$TMPDIR/
tar xf /tmp/$TMPDIR/*.tar.gz
rm /tmp/$TMPDIR/*.tar.gz

for f in `find . -type f`; do 
    ls -lah $f | A=`md5sum $f` awk '{printf "%-6s %s\n",$5,ENVIRON["A"]}'
done

