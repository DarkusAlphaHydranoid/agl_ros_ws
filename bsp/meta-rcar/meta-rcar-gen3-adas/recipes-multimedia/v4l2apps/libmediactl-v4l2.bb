DESCRIPTION = "V4L2 media controller support library"
LICENSE = "LGPL-2.1-only"
LIC_FILES_CHKSUM = " \
    file://COPYING;md5=d749e86a105281d7a44c2328acebc4b0 \
"

PR = "r0"

inherit autotools pkgconfig

SRCREV = "998aaa0fa4a594bfc8d98ce0f5971ffc083be231"
SRC_URI = " \
    git://github.com/renesas-rcar/libmediactl-v4l2.git;protocol=https;branch=rcar-gen3 \
"

S = "${WORKDIR}/git"
