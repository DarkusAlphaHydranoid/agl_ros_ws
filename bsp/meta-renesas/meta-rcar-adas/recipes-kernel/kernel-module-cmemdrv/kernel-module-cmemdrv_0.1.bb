SUMMARY = "Cache Memory Primitive Module"
LICENSE = "GPL-2.0-only & MIT"
LIC_FILES_CHKSUM = " \
    file://${S}/GPL-COPYING;md5=b234ee4d69f5fce4486a80fdaf4a4263 \
    file://${S}/MIT-COPYING;md5=fea016ce2bdf2ec10080f69e9381d378 \
"

inherit module

PR = "r0"
PV = "0.1"

RENESAS_CMEM_URL ?= "git://github.com/renesas-rcar/cmem.git;protocol=https"
SRC_URI = "${RENESAS_CMEM_URL};nobranch=1"
SRCREV:rcar-v3x = "abe21c26b5ad06909017966c7208c454e7f02b92"
SRCREV:rcar-v4x = "e67f473cddb089f71abead8bf18f618d42f515da"

S = "${WORKDIR}/git"

do_install:append () {
    install -d ${D}${includedir}/linux
    install -m 644 ${S}/cmemdrv.h ${D}${includedir}/linux/
}

KERNEL_MODULE_AUTOLOAD += "cmemdrv"
KERNEL_MODULE_PROBECONF += "cmemdrv"
module_conf_cmemdrv = "options cmemdrv bsize=0x20000000"
