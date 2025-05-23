DESCRIPTION = "Kernel module of UVCS"
LICENSE = "GPL-2.0-only & MIT"
LIC_FILES_CHKSUM = " \
    file://include/GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://src/lkm/GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://src/core/GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://src/cmn/GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://include/MIT-COPYING;md5=fea016ce2bdf2ec10080f69e9381d378 \
    file://src/lkm/MIT-COPYING;md5=fea016ce2bdf2ec10080f69e9381d378 \
    file://src/core/MIT-COPYING;md5=fea016ce2bdf2ec10080f69e9381d378 \
    file://src/cmn/MIT-COPYING;md5=fea016ce2bdf2ec10080f69e9381d378 \
"
require include/omx-control.inc
require include/rcar-gen3-path-common.inc

inherit module

COMPATIBLE_MACHINE = "(salvator-x|ulcb|ebisu)"

DEPENDS = "linux-renesas kernel-module-mmngr mmngr-user-module"

PR = "r0"

SRC_URI = "${@oe.utils.conditional('USE_VIDEO_OMX', '1', 'file://RTM8RC0000ZMX0DQ00JFL3E.tar.bz2', '', d)}"

S = "${WORKDIR}/RTM8RC0000ZMX0DQ00JFL3E"
B = "${S}/src/makefile"

EXTRA_OEMAKE = "KERNELDIR=${STAGING_KERNEL_BUILDDIR}"
EXTRA_OEMAKE += "CROSS_COMPILE=${CROSS_COMPILE}"
EXTRA_OEMAKE += "KERNELSRC=${STAGING_KERNEL_DIR}"

includedir = "${RENESAS_DATADIR}/include"

do_compile:prepend() {
    export UVCS_SRC="${S}/src"
    export UVCS_INC="${S}"
    export VCP4_SRC="${S}/src"
    export EXTRA_CFLAGS=-I${STAGING_KERNEL_DIR}/include
}

# Build UVCS kernel module without suffix
KERNEL_MODULE_PACKAGE_SUFFIX = ""

do_install() {
    # Create destination directory
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/
    install -d ${D}/${includedir}/

    # Install kernel module
    install -m 644 ${B}/uvcs_drv.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/

    # Install module symbol file
    install -m 644 ${B}/Module.symvers ${STAGING_KERNEL_BUILDDIR}/UVCS.symvers

    # Install shared header file
    install -m 644 ${S}/include/uvcs_ioctl.h ${D}/${includedir}/
}

# Clean up the module symbol file
CLEANFUNCS = "module_clean_symbol"

module_clean_symbol() {
    rm -f ${STAGING_KERNEL_BUILDDIR}/UVCS.symvers
}

PACKAGES = " \
    ${PN} \
    ${PN}-sstate \
    ${PN}-dbg \
"

FILES:${PN}-sstate = " \
    ${includedir}/uvcs_ioctl.h \
"

FILES:${PN}-dbg = "" 
ALLOW_EMPTY:${PN}-dbg = "1" 
