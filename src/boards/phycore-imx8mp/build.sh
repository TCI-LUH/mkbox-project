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

[ ! -d u-boot ] && git clone --depth 3 --branch v2021.04_2.2.0-phy10 git://git.phytec.de/u-boot-imx u-boot && (cd u-boot && git apply ../u-boot.patch)
[ ! -d linux ] && git clone --depth 3 --branch v5.15.71_2.2.0-phy4 git://git.phytec.de/linux-imx linux && (cd linux && git apply ../linux.patch)
[ ! -d imx-atf ] && git clone --depth 3 --branch  master https://git.trustedfirmware.org/TF-A/trusted-firmware-a.git imx-atf

download toolchains/aarch64-linux-gnu https://snapshots.linaro.org/gnu-toolchain/13.0-2022.11-1/aarch64-linux-gnu/gcc-linaro-13.0.0-2022.11-x86_64_aarch64-linux-gnu.tar.xz

rm -rf output
mkdir output

cd "$BASE/imx-atf"
export ARCH=arm64
export CROSS_COMPILE="$BASE/toolchains/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
make PLAT=imx8mp IMX_BOOT_UART_BASE=0x30860000 bl31
cp build/imx8mp/release/bl31.bin "$BASE/u-boot"


cd "$BASE/u-boot"
cp "$BASE/bin/lpddr4_pmu_train_1d_dmem_202006.bin" lpddr4_pmu_train_1d_dmem.bin
cp "$BASE/bin/lpddr4_pmu_train_1d_imem_202006.bin" lpddr4_pmu_train_1d_imem.bin
cp "$BASE/bin/lpddr4_pmu_train_2d_dmem_202006.bin" lpddr4_pmu_train_2d_dmem.bin
cp "$BASE/bin/lpddr4_pmu_train_2d_imem_202006.bin" lpddr4_pmu_train_2d_imem.bin
export ARCH=arm64
export CROSS_COMPILE="$BASE/toolchains/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
export ATF_LOAD_ADDR=0x970000
# make distclean
make phycore-imx8mp_defconfig
make -j$(nproc) flash.bin
cp flash.bin "$BASE/output" 

cd "$BASE/linux"
export ARCH=arm64
export CROSS_COMPILE="$BASE/toolchains/aarch64-linux-gnu/bin/aarch64-linux-gnu-"
# make distclean
make imx_v8_defconfig imx8_phytec_distro.config imx8_phytec_platform.config
make -j $(nproc)
make dtbs_install INSTALL_DTBS_PATH="$BASE/output/boot/dtbs"
cp "arch/$ARCH/boot/Image.gz" "$BASE/output/boot"
make -j $(nproc) modules_install INSTALL_MOD_PATH="$BASE/output/modules"