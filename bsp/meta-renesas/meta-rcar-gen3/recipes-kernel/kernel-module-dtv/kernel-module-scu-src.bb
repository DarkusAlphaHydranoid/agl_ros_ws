DESCRIPTION = "DTV Driver part of scu_src for Linux for the R-Car Gen3"

LICENSE = "GPL-2.0-only & MIT"
LIC_FILES_CHKSUM = " \
    file://scu_src_drv/include/GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://scu_src_drv/include/MIT-COPYING;md5=fea016ce2bdf2ec10080f69e9381d378 \
"

require include/rcar-gen3-modules-common.inc
require include/dtv-dvd-control.inc

inherit module features_check

DEPENDS = "linux-renesas"

REQUIRED_DISTRO_FEATURES = "dtv"

PN = "kernel-module-scu-src"
PR = "r0"

SRC_URI = "file://scu_src_drv.tar.gz"

S = "${WORKDIR}"

EXTRA_OEMAKE_r8a7795 += "DTV_MAKE_HW_SWITCH=HW_SUPPORT_H3"
EXTRA_OEMAKE_r8a7796 += "DTV_MAKE_HW_SWITCH=HW_SUPPORT_M3"
EXTRA_OEMAKE_r8a77965 += "DTV_MAKE_HW_SWITCH=HW_SUPPORT_M3N"

# Build DTV kernel modules without suffix
KERNEL_MODULE_PACKAGE_SUFFIX = ""

do_compile() {
    cd ${S}/scu_src_drv/drv
    oe_runmake
}

do_install () {
    # Create destination directories
    install -d ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/

    # Install kernel module
    install -m 644 ${S}/scu_src_drv/drv/scu_src_drv.ko ${D}${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/

    # Install shared header files to KERNELSRC(STAGING_KERNEL_DIR).
    # This file installed in SDK by kernel-devsrc pkg.
    install -m 644 ${S}/scu_src_drv/include/*.h ${KERNELSRC}/include
    install -m 644 ${S}/scu_src_drv/drv/Module.symvers ${KERNELSRC}/include/scu-drv.symvers
}

PACKAGES = "\
    ${PN} \
"

FILES:${PN} = " \
    ${nonarch_base_libdir}/modules/${KERNEL_VERSION}/extra/scu_src_drv.ko \
"

RPROVIDES:${PN} += "kernel-module-scu-src kernel-module-scu-src-drv"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
