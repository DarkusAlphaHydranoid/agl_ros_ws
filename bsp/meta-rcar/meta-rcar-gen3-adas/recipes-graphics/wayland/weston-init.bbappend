FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://weston_exp.sh \
"

# Add Weston configuration script
do_install:append() {
    install -d ${D}/etc/profile.d
    install -m 0755 ${WORKDIR}/weston_exp.sh ${D}/etc/profile.d
}
