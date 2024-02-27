#!/bin/bash

set -e

BASE="$(realpath $(dirname $0))"
cd "$BASE"

function download()
(
    local name="$1"
    local url="$2"
    local dest="$(dirname "$name")"
    local file="$(basename "$url")"

    # PATH="$(pwd)/$name/bin:$PATH"
    [ -d "$name" ] && return
    mkdir -p "$name"
    cd "$dest"
    curl -LO "$url"
    tar  xf "$file" -C "$(basename "$name")" -m --strip-components=1
)

[ ! -d u-boot ] && git clone --depth 3 --branch travis/odroidc4-189 https://github.com/hardkernel/u-boot.git u-boot && (cd u-boot && git apply ../u-boot.patch)
[ ! -d linux ] && git clone --depth 3 --branch 4.9.277-122 https://github.com/hardkernel/linux.git linux

download toolchains/aarch64-elf       https://releases.linaro.org/components/toolchain/binaries/4.9-2017.01/aarch64-elf/gcc-linaro-4.9.4-2017.01-x86_64_aarch64-elf.tar.xz
download toolchains/arm-eabi          https://snapshots.linaro.org/components/toolchain/binaries/7.5-2019.12-rc1/arm-eabi/gcc-linaro-7.5.0-2019.12-rc1-x86_64_arm-eabi.tar.xz
download toolchains/aarch64-linux-gnu https://snapshots.linaro.org/components/toolchain/binaries/10.2-2021.01-3/aarch64-linux-gnu/gcc-linaro-10.2.1-2021.01-x86_64_aarch64-linux-gnu.tar.xz


rm -rf output
mkdir output

cd u-boot
export ARCH=arm64
export CROSS_COMPILE="$BASE/toolchains/aarch64-elf/bin/aarch64-elf-"
export CROSS_COMPILE_ARM="$BASE/toolchains/arm-eabi/bin/arm-eabi-"
# make distclean
make odroidc4_defconfig
make -j$(nproc)
cp sd_fuse/u-boot.bin "$BASE/output"
unset CROSS_COMPILE_ARM


cd "$BASE/linux"
export ARCH=arm64
export CROSS_COMPILE="$BASE/toolchains/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
# make distclean
make odroidg12_defconfig
make -j $(nproc)
make dtbs_install INSTALL_DTBS_PATH="$BASE/output/boot/dtbs"
cp "arch/$ARCH/boot/Image.gz" "$BASE/output/boot"
make -j $(nproc) modules_install INSTALL_MOD_PATH="$BASE/output/modules"