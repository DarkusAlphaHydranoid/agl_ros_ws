require ctemplate.inc

SRC_URI = "git://github.com/svn2github/ctemplate.git;protocol=https;branch=master"
SRC_URI[md5sum] = ""
SRC_URI[sha256sum] = ""
SRCREV = "${AUTOREV}"
S = "${WORKDIR}/git"
B = "${WORKDIR}/git"

DEFAULT_PREFERENCE = "-1"
