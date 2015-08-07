# VMX Release Manager

This repository uses Nginx, fancyindex, Docker, and shell scripts to
generate a directory listing for VMX packages available on `https://files.vision.ai`.

This repository also contains useful scripts for generating links to
latest and stable versions of software builds (Linux builds as
`.tar.gz` and Mac builds as `.pkg`).  Currently used for serving the
VMX package at:

[https://files.vision.ai/vmx/](https://files.vision.ai/vmx)

### Managing Software

Software builds are versioned using `git describe --tags --dirty` and
stable builds are manually tagged using a semver like `v0.1.2`.

Checksums (MD5, SHA1, SHA256) are generated for the tarballs and their
contents.

### Nginx pretty directory listing

Included in the `fancy/` subdirectory are NgxFancyIndex files for
making nice HTML pages for listing directories and using colors to
indicate latest and stable releases. The xdrum/nginx-extras docker
image is used because it contains all of the extra goodies for Nginx
like fancyindex.

Files containing `.latest.` are listed in blue, and files containing
`.stable.` are listed in green. These are symlinks to the most recent
version.

### Directory structure

This will be used to serve files like
`https://files.vision.ai/vmx/VMXserver/Mac/VMXserver_Mac_v0.1.10.tar.gz`
which should be mapped on the filesystem as
`/www/vmx/VMXserver/Mac/VMXserver_Mac_v0.1.10.tar.gz`

### Installation Instructions

Make sure that your data is inside `/www/` and you have Docker installed.

    git clone https://github.com/VISIONAI/vmx-release-manager
    cd vmx-release-manager
    ./start.sh

This will start two Docker containers called `nginx-files` and
`nginx-files-generator`. `nginx-files` serves the files from `/www`
using the nginx configuration inside `fancyfiles.conf`, but it serves
the content on port 5000 which is only available to 127.0.0.1, and not
the outside world.

#### vision.ai SSL installation

For the SSL installation, you'll need access to the SSL certificates
as a **vision.ai admin**.

    git clone https://github.com/VISIONAI/nginx-ssl-proxy
    cd nginx-ssl-proxy
    ./proxy.sh

This will run the `nginx-proxy` Docker container, which will map the
`nginx-files` container's port to 443 using the SSL certificate.

### License

MIT License