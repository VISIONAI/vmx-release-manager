#!/bin/sh
#
# Loop infinitely and update the releases index every 60 seconds.
# Ideally run this inside a screen session or setup a cronjob to do
# something similar.  This might not be the most elegant way of doing
# this, but it works!
# 
# Copyright 2014 Tomasz Malisiewicz (tom@vision.ai)
while true; do
    ./make_latest.sh VMXdocs .
    ./make_latest.sh VMXserver Linux
    ./make_latest.sh VMXserver Mac
    ./make_latest.sh VMXmiddle Linux
    ./make_latest.sh VMXmiddle Mac
    ./make_latest.sh vmxAppBuilder .
    ./make_latest.sh MacInstaller .
    #ln -s /www/vmx/MacInstaller/MacInstaller.latest.pkg /www/releases.VMX.pkg
    sleep 60
done
