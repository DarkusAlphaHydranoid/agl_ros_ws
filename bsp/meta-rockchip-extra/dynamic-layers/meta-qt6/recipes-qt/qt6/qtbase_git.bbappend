FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " file://0001-HACK-qtbase-build-using-libmali.patch"
