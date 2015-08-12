# VMX Release Manager

This repository uses Nginx, fancyindex, Docker, and shell scripts to
generate a directory listing for VMX software packages available inside a
directory tree on disk (e.g., /www/)

This repository also contains useful scripts for generating links to
latest and stable versions of software builds (Linux builds as
`.tar.gz` and Mac builds as `.pkg`). Currently used for serving the
VMX package components and determining if you have the latest version
of our software. See the live version here:

[https://files.vision.ai/vmx/](https://files.vision.ai/vmx)

### Managing Component Versions

Software builds are versioned using `git describe --tags --dirty` and
stable builds are manually tagged using a semver like `v0.1.2`. The
complete VMX package is made up of 4 separate components: VMXdocs,
VMXserver, VMXmiddle, and vmxAppBuilder. There are Linux/Mac builds
for both VMXserver and VMXmiddle, as well as an additional Mac
Installer, for a total of 7 main directories.

Checksums (MD5) are generated for the tarballs, their
contents, and an easy JSON file is generated for versioning from other
applications.

### Nginx pretty directory listing customization

Included in the `fancy/` subdirectory are NgxFancyIndex files for
making nice HTML pages for listing directories and using colors to
indicate latest and stable releases. There is a global file index
called index.html and a default favicon.ico. The xdrum/nginx-extras
docker image is used because it contains all of the extra goodies for
Nginx like fancyindex.

Files containing `.latest.` are listed in blue, and files containing
`.stable.` are listed in green. These are symlinks to the most recent
version.

### Directory structure

We typically serve files with names like
`https://files.vision.ai/vmx/VMXserver/Mac/VMXserver_Mac_v0.1.10.tar.gz`
which should be mapped on the filesystem as
`/www/vmx/VMXserver/Mac/VMXserver_Mac_v0.1.10.tar.gz`

### Installation Instructions

Make sure that your data is inside `/www/` and you have Docker installed.

    git clone https://github.com/VISIONAI/vmx-release-manager
    cd vmx-release-manager
    ./start.sh

This will start three Docker containers called `nginx-files`,
`nginx-files-http` and `nginx-files-generator`. `nginx-files` serves
the files from `/www` using the nginx configuration inside
`fancyfiles.conf`, but it serves the content on port 5000 which is
only available to 127.0.0.1, and not the outside world. Currently we
serve files.vision.ai over http in addition to https, but will likely
be removed in the future.

The `nginx-files-generator` container will periodically regenerate the
.json files and directlry listing content files.  Just take a look at
`looper.sh` if you want to see how the json generation bit works.

#### vision.ai SSL installation

For the SSL installation, you'll need access to the SSL certificates
as a **vision.ai admin**.

    git clone https://github.com/VISIONAI/nginx-ssl-proxy
    cd nginx-ssl-proxy
    ./proxy.sh

This will run the `nginx-proxy` Docker container, which will map the
`nginx-files` container's port to 443 using the SSL certificate.

#### Sending files to files.vision.ai

If you want to send a file to the fileserver and you are a **vision.ai
admin**, then make sure that files.vision.ai has your SSH key and then use scp:

    scp vmxAppBuilder_v1.0.0.tar.gz root@files.vision.ai:/www/vmx/vmxAppBuilder/


### Testing
If something doesn't appear to work, make sure the requests are coming in:

    docker logs -f nginx-files
    docker logs -f nginx-files-http

To see the file generation log, just type:
    
    docker logs -f nginx-files-generator

You can also inspect the logs on the proxy server

    docker logs -f nginx-ssl-proxy

### License

Copyright vision.ai, LLC 2015
MIT License