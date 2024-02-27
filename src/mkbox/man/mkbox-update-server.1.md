---
title: mkbox-update-server
section: 1
header: User Manual
footer: mkbox-update-server
date: August 23, 2023
---
# NAME

mkbox update server - HTTP based image update server for the mkbox-project

# SYNOPSIS

**update-server**

# DESCRIPTION

**update-server** is an HTTP server based on Python 3 that offers endpoints to the update mechanism of the Linux box. This tool can send update responses to a development environment for local build images, or run on a production server, in which case an nginx reverse proxy is recommended to increase security.

# HTTP ENDPOINTS

**/list/***[search]*
: list all available images, each line contains "*box-name*/*image-name*". If the search is provided then the results are filtered by the search term.

**/update/**_box_name/image_name_*/[buildID]*
: request a image of *box_name* and the *image_name* (normally contains: *box_name*-*board*[*-branch*][*-version*]) and get a tar file as a response.
This tar file contains the zstd compressed image and the sha256 checksum of the compressed- and raw image.
If the *buildID* is specified then the update server checks if there is a different build on this server, if not the response contains an empty tar file.


# EXAMPLES
**HOST="0.0.0.0" PORT=8000 update-server**
: start an update server on all network interfaces on port 8000.

**HOST=0.0.0.0  IMAGE_PATH="boxes/" ./mkbox/tools/update-server**
: start an update server in your mkbox-project folder and provieds all local build images as updates.

# ENVIRONMENT

**HOST**
: Server address to bind to. Pass 0.0.0.0 to listen on all interfaces including the external one. (default: 127.0.0.1)

**PORT**
: Server port to bind to. Values below 1024 require root privileges. (default: 8080)

**IMAGE_PATH**
: Image search path, this path must be pointed to a directory with the content of "*box-name*/*image-file*". (default: ./)

**STOP_AFTER_REQUEST**
: Stop the server after the first update request, this could be useful for an update script. (default: false)

# SEE ALSO
**mkbox**(1) **BOXBUILD**(8)

# AUTHORS
Current Maintainers:

- Ferdinand Lange <lange@iftc.uni-hannover.de>

# COPYRIGHT

MIT License

Copyright (c) Institute of Technical Chemistry - Leibniz University Hannover

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
