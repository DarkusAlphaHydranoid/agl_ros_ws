SUMMARY = "Bluetooth firmare files for WL18xx combo modules"
LICENSE = "TI-TFL"
LIC_FILES_CHKSUM = "file://LICENSE;md5=f39eac9f4573be5b012e8313831e72a9"

# Use the commit ID for PV since several different firmware versions
# are mixed together.
PV = "git${SRCPV}"

SRC_URI = "git://git.ti.com/ti-bt/service-packs.git;branch=master"
SRCREV = "6c9104f0fb7ca1bfb663c61e9ea599b3eafbee67"

S = "${WORKDIR}/git"

inherit allarch

CLEANBROKEN = "1"

do_compile[noexec] = "1"
do_configure[noexec] = "1"

do_install() {
    install -d  ${D}${nonarch_base_libdir}/firmware/ti-connectivity/
    oe_runmake "DEST_DIR=${D}" "BASE_LIB_DIR=${nonarch_base_libdir}" install
}

FILES:${PN} = "${nonarch_base_libdir}/firmware/ti-connectivity/*"
