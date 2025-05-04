CXXFLAGS += "-Wno-float-equal"

FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI += " \
    file://ignore-float-equal-error.patch \
"