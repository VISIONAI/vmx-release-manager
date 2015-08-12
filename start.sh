#!/bin/sh
#
# Simple script to re-start the files.vision.ai container, which has
# the name nginx-files as well as the generator container, which has
# the name nginx-files-generator.
#
# Copyright vision.ai, LLC 2015

cd `dirname $0`

#Stop our containers
docker stop nginx-files && docker rm -v nginx-files
docker stop nginx-files-http && docker rm -v nginx-files-http
docker stop nginx-files-generator && docker rm -v nginx-files-generator

#This will serve the /www directory using the fancyfiles.conf
#configuration file. Note that we are uxing the xdrum/nginx-extras
#server which has fancyindex pre-compiled.
docker run -d --name nginx-files \
    -p 127.0.0.1:5000:80 \
    -e VIRTUAL_HOST=files.vision.ai \
    -v `pwd`/fancyfiles.conf:/etc/nginx/sites-enabled/default:ro \
    -v `pwd`/fancy:/fancy:ro \
    -v /www/vmx:/usr/share/nginx/html/vmx:ro \
    -v /www/releases:/usr/share/nginx/html/releases:ro \
    -v /www/images:/usr/share/nginx/html/images:ro \
    xdrum/nginx-extras:latest

docker run -d --name nginx-files-http \
     -p 80:80 \
     -v `pwd`/fancyfiles.conf:/etc/nginx/sites-enabled/default:ro \
     -v `pwd`/fancy:/fancy:ro \
     -v /www/vmx:/usr/share/nginx/html/vmx:ro \
     -v /www/releases:/usr/share/nginx/html/releases:ro \
     -v /www/images:/usr/share/nginx/html/images:ro \
     xdrum/nginx-extras:latest


#Run the generator script which will watch for new files
docker run -d --name nginx-files-generator \
    -v /www:/www \
    -v `pwd`/scripts:/root:ro \
    ubuntu:latest /bin/sh -c "cd /root && ./looper.sh"


