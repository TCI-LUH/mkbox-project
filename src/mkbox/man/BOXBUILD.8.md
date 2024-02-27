---
title: BOXBUILD
section: 8
header: User Manual
footer: BOXBUILD
date: August 23, 2023
---
# NAME
BOXBUILD - mkbox build description file

# SYNOPSIS

**BOXBUILD**

# DESCRIPTION

This manual page provides general rules about BOXBUILDs.

# OPTIONS AND DIRECTIVES
The following is a list of standard options and directives available for use in a **BOXBUILD**. These are all understood and interpreted by **mkbox**.

If you need to create any custom variables for use in your build process, it is recommended to prefix their name with an _ (underscore). This will prevent any possible name clashes with internal **mkbox** variables.  

**name**  
: Contains the name of this box.

**update_server_http**
: Specify the default update server url.

**apks: array**
: Contains the installing alpine packages in the root file system.

**initramfs_apks: array**
: Contains the installing alpine packages in the initramfs file system.

**domain**
: The **domain** setting specifies the base domain name used to request update information from the DNS Server's FQDN. This is a component of the update configuration overwrite. See the **use_force_update_dns** option.

**use_force_update_dns**
: If this field is not *false* then the update configurations can be changed over the DNS. The config file */boot/update.txt* has a higher priority than the DNS method. (default: *true*)
Following TXT records are queried of *\<MAC-Address>.$domain* and used to change the update configuration:

- **box_name** the new target image name
- **box_branch** the branch name of the new image
- **box_version** the version name of the new image
- **box_update_server** the base url of the update server

**use_force_update_config**
: If this field is not *false* then the update configurations can be changed with a config file: */boot/update.txt*. The config file has a higher priority than the DNS method. (default: *true*)
In this config file can be specified the following variables:

- **force_update_name** the new target image name
- **force_update_branch** the branch name of the new image
- **force_update_version** the version name of the new image
- **force_update_server_http** the base url of the update server.

## BOARD DESCRIPTION

The following list of options and directives is board-specific and should only be defined in a board **BOXBUILD**.

**arch**
: Contains the architecture of this single-board-computer and is used to install the correct Alpine packages.

**first_sector**
: Described the first sector of the boot partition, the space before the first sector is reserved for the u-boot boot loader.

**root_size**
: Specify the root partition size. For extended images the **inc_root_size(** _size_ **)** function is recommended to increase the root file system

**boot_size**
: Specify the boot partition size.

**storage_dev**
: This field contains the internal storage device with the boot and root file system, the linux-box init script using this field to mount the file system.

**external_storage_dev**
: This field contains the external storage device, the linux-box init script using this field to copy the content of this device to the device specified in **storage_dev**.

# FUNCTIONS
In addition to the above directives, BOXBUILDs require a set of functions that provide instructions to build and install the image.
This is directly sourced and executed by **mkbox**, so anything that Bash or the system has available is available for use here.

**build()**
: This optional function can be used to build and prepare the requirements of this image.

**root()**
: The **root()** function is used to install and modify the root file system and is called after the installation of the **apks** packages.

**initramfs()**
: The **initramfs()** function is used to install and modify the initramfs file system and is called after the installation of the **initramfs_apks** packages.

**flash()**
: Only the boards BOXBUILDs should defile a **flash()** function to flash the bootloader and prepare the boot process, this function would be overridden and not extended by the extend command.

All of the above variables such as $pkgname and $pkgver are available for use in the packaging functions. In addition, makepkg defines the following variables.

**SRC**
: This contains the current *box* root directory and can be used to copy the needed files into the image.
   
**DEST**
: This contains the directory where **mkbox** bundles the installed package. This directory will become the root directory of your built package.

**DEV**
: The flash function has in addition access to the **DEV** variable, which contains the loop device of this image and can be used to flash the u-boot bootloader.

Additional **mkbox** provides the following utility functions.

**extend(** _BOXBUILD_ **)**
: This function allows you to extend this box with the description on a target BOXBUILD. This should be the first call in a BOXBUILD file, the extended description can overwrite defined variables.

**inc_root_size(** _size_ **)**
: increase the size of the initial root filezstem with an amount of _size_. 

**enable_service(** _service_name_, _runlevel_ **)**
: To enable open-rc serviced the function **enable_service** can be used. It requires the service name and a run level as an argument.

**disable_service(** _service_name_, _runlevel_ **)**
: To disable open-rc serviced the function **enable_service** can be used. It requires the service name and a run level as an argument.

# EXAMPLE
The following is an example BOXBUILD for the linux-box. For more examples, look through the build files of the boxes repositories. 
```
extend "$BOXES_BASE/linux-box/BOXBUILD"

name="docker-box"
inc_root_size 250M

apks+=(
    openssh
    docker
    ca-certificates
    openssl
)

function root()
{
    cp -r "$SRC/root/"* "$DEST"

    enable_service "docker" "default"
    enable_service "sshd" "default"
    enable_service "update-ca-certificates" "default"
}
```

# SEE ALSO
**mkbox**(1) **mkbox-update-server**(1)
 
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
