---
title: mkbox
section: 1
header: User Manual
footer: mkbox
date: August 23, 2023
---
# NAME

mkbox - a tool to automatically create application-specific Linux images

# SYNOPSIS
**mkbox** *file*

# DESCRIPTION

In modern IoT applications with multiple smart devices, for example in a digital laboratory, it is desirable to have a solution to maintain all software installations and configurations.
With this tool, you can build an application-specific Linux image by specifying a description file **BOXBUILD** (see: **BOXBUILD**(8)). This allows the automatic build process to be integrated with a build pipeline like gitlab-ci. Additionally, the description file provides documentation and information on which software and which configurations are contained in an image.
The linux-box base image contains a preboot update mechanism via http/https for an easy way to exchange or update the images on a specific device.

# EXAMPLES

**BOARD="odroid-c4" sudo -E mkbox BOXBUILD**
: Build an application-specific linux-image inside the mkbox-project for the odroid-c4 board:


# ENVIRONMENT

**BOARD**
: Name of the single-board-computer. (required)

**BOXES_BASE**
: The search path for the boxes. (default: *mkbox_root_path*/../boxes)

**BOARDS_BASE**
: The search path for the boards. (default: *mkbox_root_path*/../boards)

**BOX_BRANCH**
: The branch name of this box build. (default unset)

**BOX_VERSION**
: The version of this box build. (default unset)

**BOX_DOMAIN**
: Overwrite the base domain name used by update management via DNS

**BOX_UPDATE_SERVER_HTTP**
: Overwrite the default http update server url, otherwise use the specification from the *BOXBUILD* files

**APK_BRANCH**
: Specify the used apk branch (default edge)

# FILES
*BOXBUILD*
: The description file of a linux-box, this file describes how the image is built and which software packages are included.

# SEE ALSO
**mkbox-update-server**(1) **BOXBUILD**(8)

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
