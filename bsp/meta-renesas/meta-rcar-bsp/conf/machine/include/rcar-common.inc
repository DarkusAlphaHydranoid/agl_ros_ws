require conf/machine/include/${SOC_FAMILY}.inc

MACHINE_FEATURES = ""

KERNEL_IMAGETYPE = "Image"
IMAGE_FSTYPES += "tar.bz2 wic.gz wic.bmap wic.gz.sha256sum wic.gz.crc"
WKS_FILE ?= "image-v3x.wks"

COMPRESSIONTYPES += "crc"
CONVERSION_CMD:crc = "${RECIPE_SYSROOT_NATIVE}/usr/bin/perl-native/perl \
                      ${RECIPE_SYSROOT_NATIVE}/usr/bin/crc32 \
                      ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${type} \
                      > ${IMAGE_NAME}${IMAGE_NAME_SUFFIX}.${type}.crc"

SERIAL_CONSOLES = "115200;ttySC0"

# Configuration for kernel
PREFERRED_PROVIDER_virtual/kernel = "linux-renesas"
OLDEST_KERNEL = "5.10"

# u-boot
EXTRA_IMAGEDEPENDS += " u-boot arm-trusted-firmware"

# Add variable to Build Configuration in build log
BUILDCFG_VARS:append = " SOC_FAMILY"
