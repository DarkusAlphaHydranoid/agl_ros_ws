require recipes-kernel/linux-libc-headers/linux-libc-headers.inc

RENESAS_BSP_URL = " \
    git://github.com/renesas-rcar/linux-bsp.git"
BRANCH = "${@oe.utils.conditional("USE_SAFE_RENDERING", "1", "rcar-5.1.4.rc3/saferendering.rc9", "v5.10.194/rcar-5.3.1", d)}"
SRC_URI = "${RENESAS_BSP_URL};branch=${BRANCH};protocol=https"
SRCREV = "${@oe.utils.conditional("USE_SAFE_RENDERING", "1", \
    "e2037726e5f6c3d6de6bc7d78b50ea9e2248a00d", \
    "6b085f452e4578dca5ba4f2d73ba1b8e0129c29a", d)}"

# Add module.lds
SRC_URI:append = " \
    file://0001-scripts-Add-module.lds-to-fix-out-of-tree-modules-bu.patch \
"

LIC_FILES_CHKSUM = "file://COPYING;md5=6bc538ed5bd9a7fc9398086aedcd7e46"

S = "${WORKDIR}/git"
