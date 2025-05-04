FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0003-client-Assign-proxy-to-default-queue-when-releasing-.patch \
    "
