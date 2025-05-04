SUMMARY = "Tools for building cr7 loader"
LICENSE = "GPL-2.0-only"
LIC_FILES_CHKSUM = "file://${COREBASE}/meta/files/common-licenses/GPL-2.0;md5=801f80980d171dd6425610833a22dbe6"

PV = "9.2-2019.12"

EABI = "arm-none-eabi"
TOOLS = "gcc-arm-${PV}-${BUILD_ARCH}-${EABI}"

inherit native

SRC_URI = " \
    https://developer.arm.com/-/media/Files/downloads/gnu-a/9.2-2019.12/binrel/${TOOLS}.tar.xz \
"

SRC_URI[md5sum] = "f7cc38b807c9b9815e5b0fb8440e3657"
SRC_URI[sha256sum] = "ac952d89ae0fc3543e81099e7d34917efc621f5def112eee843fd1ce755eca8c"

do_unpack[noexec] = "1"
do_configure[noexec] = "1"
do_compile[noexec] = "1"

do_install() {
    install -d ${D}${libexecdir}
    tar -xvf ${DL_DIR}/${TOOLS}.tar.xz -C ${D}${libexecdir}
    ln -sf ${TOOLS} ${D}${libexecdir}/${PN}
}
