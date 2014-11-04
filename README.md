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

### nginx configuration file
You'll need a configuration file for nginx, which is not specified in
this repository.
