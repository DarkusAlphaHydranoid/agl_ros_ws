DESCRIPTION = "DVD Core-Middleware for Linux for the R-Car Gen3"
LICENSE = "CLOSED"

require include/rcar-gen3-modules-common.inc
require include/dtv-dvd-control.inc

inherit features_check

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = " \
    kernel-module-vspm-if mmngr-user-module \
    vspmif-user-module kernel-module-vspm \
    omx-user-module kernel-module-uvcs-drv \
"

REQUIRED_DISTRO_FEATURES = "dvd"

PN = "dvd-user-module"
PR = "r0"

SRC_URI_DVD_SW = "file://Software.tar.gz"

SRC_URI = " \
    ${SRC_URI_DVD_SW} \
"

S = "${WORKDIR}"

includedir = "${RENESAS_DATADIR}/include"

# do_configure() nothing
do_configure[noexec] = "1"
# do_compile() nothing
do_compile[noexec] = "1"

do_install() {
    # Create destination folders
    install -d ${D}/${libdir}
    install -d ${D}${RENESAS_DATADIR}/include

    # Copy library
    install -m 644 ${S}/${baselib}/*.a ${D}/${libdir}

    # Copy shared header files
    install -m 644 ${S}/include/*.h ${D}${RENESAS_DATADIR}/include
}

PACKAGES = " \
    ${PN} \
    ${PN}-dev \
    ${PN}-staticdev \
"

FILES:${PN} = ""
ALLOW_EMPTY:${PN} = "1"

FILES:${PN}-dev = " \
    ${RENESAS_DATADIR}/include/*.h \
"
FILES:${PN}-staticdev = " \
    ${libdir}/*.a \
"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
