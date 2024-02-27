#!/bin/bash

set -e

which lzop &> /dev/null || (echo "lzop is required" && exit -1)
which bison &> /dev/null || (echo "bison is required" && exit -1)
which flex &> /dev/null || (echo "flex is required" && exit -1)

BASE="$(realpath $(dirname $0))"
cd "$BASE"

function download()
(
    local name="$1"
    local url="$2"
    local dest="$(dirname "$name")"
    local file="$(basename "$url")"

    [ -d "$name" ] && return
    mkdir -p "$name"
    cd "$dest"
    curl -LO "$url"
    tar  xf "$file" -C "$(basename "$name")" -m --strip-components=1
)

[ ! -d u-boot ] && git clone --depth 3 --branch v2020.10 https://github.com/beagleboard/u-boot u-boot #&& (cd u-boot && git apply ../u-boot.patch)
[ ! -d linux ] && git clone --depth 3 --branch 5.10.41-ti-r14 https://github.com/beagleboard/linux.git linux #&& (cd linux && git apply ../linux.patch)

download toolchains/arm-linux-gnueabihf https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-linux-gnueabihf/gcc-linaro-6.5.0-2018.12-x86_64_arm-linux-gnueabihf.tar.xz
download toolchains/arm-eabi            https://releases.linaro.org/components/toolchain/binaries/6.5-2018.12/arm-eabi/gcc-linaro-6.5.0-2018.12-x86_64_arm-eabi.tar.xz

rm -rf output
mkdir output

# export PATH="$BASE/toolchains/arm-linux-gnueabihf/bin:$PATH"

cd u-boot
export ARCH=arm
export CROSS_COMPILE="$BASE/toolchains/arm-eabi/bin/arm-eabi-"
# make distclean
make am335x_evm_defconfig
make -j $(nproc)
make -j $(nproc) env
cp MLO "$BASE/output"
cp u-boot.img "$BASE/output"


cd "$BASE/linux"
export ARCH=arm
export CROSS_COMPILE="$BASE/toolchains/arm-linux-gnueabihf/bin/arm-linux-gnueabihf-"
export KBUILD_DEBARCH=armhf
# make distclean
make bb.org_defconfig
make -j $(nproc)
make dtbs_install INSTALL_DTBS_PATH="$BASE/output/boot/dtbs"
cp "arch/$ARCH/boot/zImage" "$BASE/output/boot"
make -j $(nproc) modules_install INSTALL_MOD_PATH="$BASE/output/modules"