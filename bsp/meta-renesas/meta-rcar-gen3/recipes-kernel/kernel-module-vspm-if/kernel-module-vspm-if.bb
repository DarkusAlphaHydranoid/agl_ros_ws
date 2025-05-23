DESCRIPTION = "VSP Manager Interface driver for the R-Car Gen3"

LICENSE = "GPL-2.0-only & MIT"
LIC_FILES_CHKSUM = " \
    file://GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://MIT-COPYING;md5=0ebf15a927e436cec699371cd890775c \
"

require include/rcar-gen3-modules-common.inc

inherit module

DEPENDS = "linux-renesas kernel-module-vspm"

PN = "kernel-module-vspm-if"
PR = "r0"

VSPMIF_DRV_URL = "git://github.com/renesas-rcar/vspmif_drv.git"
BRANCH = "rcar_gen3"
SRC_URI = "${VSPMIF_DRV_URL};branch=${BRANCH};protocol=https"
SRCREV = "2fdb2838a5625e4231f1cff5d10079acc4954952"

S = "${WORKDIR}/git"
B = "${WORKDIR}/git/vspm_if-module/files/vspm_if/drv"

includedir = "${RENESAS_DATADIR}/include"

# Build VSP Manager Interface kernel module without suffix
KERNEL_MODULE_PACKAGE_SUFFIX = ""

do_install () {
    # Create destination directories
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
    install -d ${D}/${includedir}

    # Install shared library to KERNELSRC(STAGING_KERNEL_DIR) for reference from other modules
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 644 ${B}/Module.symvers ${KERNELSRC}/include/vspm_if.symvers

    # Install kernel module
    install -m 644 ${B}/vspm_if.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/

    # Install shared header files to KERNELSRC(STAGING_KERNEL_DIR)
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 644 ${B}/../include/vspm_if.h ${KERNELSRC}/include/

    # Install shared header file
    install -m 644 ${B}/../include/vspm_if.h ${D}/${includedir}/
}

PACKAGES = "\
    ${PN} \
    ${PN}-dev \
    ${PN}-dbg \
"

FILES:${PN} = " \
    ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/vspm_if.ko \
"

FILES:${PN}-dbg = ""
ALLOW_EMPTY:${PN}-dbg = "1"

