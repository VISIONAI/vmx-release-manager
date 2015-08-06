# VMX Release Manager

Useful scripts for generating links to latest and stable versions of
software builds (Linux builds as `.tar.gz` and Mac builds as `.pkg`).
Currently used at:

[https://files.vision.ai/vmx/](https://files.vision.ai/vmx)

### managing software
Software builds are versioned using `git describe --tags --dirty` and
stable builds are manually tagged using a semver like `v0.1.2`.

### nginx pretty directory listing
Included in the fancy/ subdirectory are NgxFancyIndex files for making
nice HTML pages for listing directories and using colors to indicate
latest and stable releases.

### Installation instructions

Make sure that your data is inside `/www/` and you have Docker installed.

    git clone https://github.com/VISIONAI/vmx-release-manager
    cd vmx-release-manager
    ./start.sh


### vision.ai SSL installation

For the SSL installation, you'll need access to the SSL certificates
as a vision.ai admin.

    git clone https://github.com/VISIONAI/nginx-ssl-proxy
    cd nginx-ssl-proxy
    ./proxy.sh


### License

MIT License