#!/bin/sh
#
# Simple script to re-start the files.vision.ai container, which has
# the name nginx-files
# Copyright vision.ai, LLC 2015

cd `dirname $0`
docker stop nginx-files && docker rm -v nginx-files
docker stop nginx-files-generator && docker rm -v nginx-files-generator

#This will serve the /www directory using the fancyfiles.conf
#configuration file. Note that we are uxing the xdrum/nginx-extras
#server which has fancyindex pre-compiled.
docker run -d --name nginx-files \
    -p 127.0.0.1:5000:80 \
    -e VIRTUAL_HOST=files.vision.ai \
    -v `pwd`/fancyfiles.conf:/etc/nginx/sites-enabled/default:ro \
    -v `pwd`/fancy:/fancy:ro \
    -v /www:/usr/share/nginx/html:ro \
    xdrum/nginx-extras

docker run -d --name nginx-files-generator \
    -v /www:/www \
    -v `pwd`/scripts:/root \
    ubuntu /bin/sh -c "cd /root && ./looper.sh"


