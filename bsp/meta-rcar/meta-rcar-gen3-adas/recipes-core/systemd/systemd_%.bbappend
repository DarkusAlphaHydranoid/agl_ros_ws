FILESEXTRAPATHS:append := '${THISDIR}/${PN}:'

SRC_URI:append = " \
    file://70-eth0.network \
    ${@bb.utils.contains("DISTRO_FEATURES", "surroundview", "file://70-dummy0.network", "", d)} \
"

FILES:${PN} += "${sysconfdir}/systemd/network/*"

USERADD_PARAM:${PN} += "; --system systemd-network "

do_install:append() {
    install -d ${D}${sysconfdir}/systemd/network/
    install -m 0644 ${WORKDIR}/*.network  ${D}${sysconfdir}/systemd/network/
}
