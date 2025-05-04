FILESEXTRAPATHS:append := "${THISDIR}/files:"

SRC_URI:append:rcar-gen3 = " \
    file://main.conf \
"

PACKAGECONFIG:append = " experimental"
PACKAGECONFIG[experimental] = "--enable-experimental,--disable-experimental,"

NOINST_TOOLS_EXPERIMENTAL:remove = " tools/bdaddr"


do_install:append:rcar-gen3() {
    install -d ${D}/etc/bluetooth

    install -m 644 ${WORKDIR}/main.conf ${D}/${sysconfdir}/bluetooth/
}
