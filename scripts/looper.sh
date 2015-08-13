#!/bin/sh
#
# Loop infinitely and update the releases index every 60 seconds.
# Ideally run this inside a screen session or setup a cronjob to do
# something similar.  This might not be the most elegant way of doing
# this, but it works!
# 
# Copyright 2015 Tom Malisiewicz (tom@vision.ai)

export ROOTDIR=/www/vmx/
if [ ! -e $ROOTDIR ]; then
    echo "Cannot find ROOTDIR=$ROOTDIR"
    exit 1
fi

SLEEPTIMER=0

while true; do
    ./make_latest.sh VMXserver Linux
    ./make_latest.sh VMXserver Mac

    ./make_latest.sh VMXmiddle Linux
    ./make_latest.sh VMXmiddle Mac

    ./make_latest.sh vmxAppBuilder .
    ./make_latest.sh MacInstaller .
    ./make_latest.sh VMXdocs .
    echo "Sleeping for" $SLEEPTIMER "seconds"
    sleep $SLEEPTIMER
done
