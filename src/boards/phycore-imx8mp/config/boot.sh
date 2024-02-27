fsuuid mmc ${mmcdev}:${mmcroot} uuid;
setenv bootargs "console=${console},115200 root=PARTUUID=${uuid} rw rootwait";

setenv initramfs_addr_r 0x48000000;
fatload mmc ${mmcdev}:${mmcpart} $initramfs_addr_r initramfs;
setexpr dtb_addr_r $initramfs_addr_r + $filesize;
fatload mmc ${mmcdev}:${mmcpart} $dtb_addr_r dtbs/freescale/imx8mp-phyboard-pollux-rdk.dtb;
setexpr kernel_addr_r $dtb_addr_r + $filesize;
fatload mmc ${mmcdev}:${mmcpart} $kernel_addr_r Image.gz;
setenv kernel_comp_size $filesize;
setenv kernel_comp_addr_r $loadaddr;

booti $kernel_addr_r $initramfs_addr_r $dtb_addr_r;