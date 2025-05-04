DESCRIPTION = "ICCOM kernel module for Renesas R-Car Gen3"

LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263"

require include/rcar-gen3-modules-common.inc
inherit module

COMPATIBLE_MACHINE = "eagle|condor|v3msk|v3hsk"

DEPENDS = "linux-renesas"
PN = "kernel-module-iccom"
PR = "r0"

SRC_URI = "git://github.com/CogentEmbedded/kernel-module-iccom.git;branch=master;protocol=https"
SRCREV = "a8c50ea65865ca72c7f53e8fcf893b6b512c3db2"
S = "${WORKDIR}/git"

do_compile() {
    # Build kernel module
    cd ${S}/
    make -C ${KBUILD_OUTPUT} M=${S} modules
}

do_install () {
    # Create destination directory
    install -d ${D}/lib/modules/${KERNEL_VERSION}/extra/
    install -d ${STAGING_KERNEL_DIR}/include
    install -d ${STAGING_KERNEL_DIR}/include/linux


    # Install kernel module
    install -m 644 ${B}/iccom.ko ${D}/lib/modules/${KERNEL_VERSION}/extra/

    # Install shared library to STAGING_KERNEL_DIR for reference from other modules
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 0644 ${S}/Module.symvers ${STAGING_KERNEL_DIR}/include/iccom.symvers

    # Install shared header files to STAGING_KERNEL_DIR
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 0644 ${S}/public/iccom.h ${STAGING_KERNEL_DIR}/include/linux/iccom.h
}

# Autoload ICCOM Driver
KERNEL_MODULE_AUTOLOAD += "iccom"
