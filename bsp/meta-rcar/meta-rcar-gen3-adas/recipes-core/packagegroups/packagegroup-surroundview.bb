DESCRIPTION = "Packages required for GPU Surroundview demo"

LICENSE = "GPL-3.0-only & BSD-3-Clause & MIT & GPL-2.0-or-later & LGPL-2.0-or-later & LGPL-2.1-or-later"

LICENSE_FLAGS = "commercial"

inherit packagegroup

PACKAGES = " \
    packagegroup-surroundview \
"

RDEPENDS:packagegroup-surroundview = " \
    glm \
    gstreamer1.0-omx \
    gstreamer1.0-plugins-base-app libgstapp-1.0 \
    libmediactl-v4l2 \
    libspnav \
    nlopt \
    spacenavd \
    yaml-cpp \
"
