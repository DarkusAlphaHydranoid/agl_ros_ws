SUMMARY = "GFlags library"
DESCRIPTION = "The gflags package contains a C++ library that implements commandline flags processing"

LICENSE = "BSD-3-Clause"
LIC_FILES_CHKSUM = "file://${S}/COPYING.txt;md5=c80d1a3b623f72bb85a4c75b556551df"

SRC_URI = "git://github.com/gflags/gflags.git;branch=master;protocol=https"
SRCREV = "14c0e93755d5a32c3d2029d83094564b8823b7b4"

S = "${WORKDIR}/git"

inherit cmake

RDEPENDS:${PN} += "bash"

EXTRA_OECMAKE = "-DBUILD_SHARED_LIBS=ON -DINSTALL_HEADERS=ON -DINSTALL_SHARED_LIBS=ON"

FILES:${PN}-dev += " \
    ${libdir}/cmake \
"
