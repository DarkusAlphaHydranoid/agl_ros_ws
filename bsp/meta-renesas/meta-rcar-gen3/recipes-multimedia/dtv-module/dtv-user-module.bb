DESCRIPTION = "ISDB-T DTV Software Package for Linux for the R-Car Gen3"
LICENSE = "CLOSED"

require include/rcar-gen3-modules-common.inc
require include/dtv-dvd-control.inc

inherit features_check

PACKAGE_ARCH = "${MACHINE_ARCH}"

DEPENDS = " \
    kernel-module-vspm-if mmngr-user-module \
    vspmif-user-module kernel-module-vspm \
    omx-user-module kernel-module-uvcs-drv \
    kernel-module-scu-src kernel-module-ssp \
    kernel-module-tddmac kernel-module-tsif \
"

REQUIRED_DISTRO_FEATURES = "dtv"

PN = "dtv-user-module"
PR = "r0"

SRC_URI_DTV_SW = "file://Software.tar.gz"
SRC_URI_DTV_UDF = "file://Reference.tar.gz"

SRC_URI = " \
    ${SRC_URI_DTV_SW} \
    ${SRC_URI_DTV_UDF} \
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
    install -d ${D}${RENESAS_DATADIR}/src/dtv/reference

    # Copy library
    install -m 644 ${S}/${baselib}/*.a ${D}/${libdir}/

    # Copy shared header files
    install -m 644 ${S}/include/*.h ${D}${RENESAS_DATADIR}/include

    # Copy reference files
    install -m 644 ${S}/userfunc/*.h ${D}${RENESAS_DATADIR}/src/dtv/reference
    install -m 644 ${S}/userfunc/*.c ${D}${RENESAS_DATADIR}/src/dtv/reference
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
    ${RENESAS_DATADIR}/src/dtv/reference/* \
"
FILES:${PN}-staticdev = " \
    ${libdir}/*.a \
"
INHIBIT_PACKAGE_DEBUG_SPLIT = "1"
