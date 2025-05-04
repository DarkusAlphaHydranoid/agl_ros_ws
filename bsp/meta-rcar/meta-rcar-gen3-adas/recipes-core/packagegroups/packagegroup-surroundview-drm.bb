DESCRIPTION = "Packages required for DRM Surroundview demo"

LICENSE = "GPL-2.0-only & GPL-3.0-only & BSD-3-Clause & MIT & GPL-2.0-or-later & LGPL-2.0-or-later"

inherit packagegroup

PACKAGES = " \
    packagegroup-surroundview-drm \
"

RDEPENDS:packagegroup-surroundview-drm = " \
    gstreamer1.0-plugins-base libgstallocators-1.0 \
    gstreamer1.0-plugins-base-app libgstapp-1.0 \
    kernel-module-mmngr \
    kernel-module-mmngrbuf \
    libdrm \
    libspnav \
    mmngr-user-module \
    spacenavd \
"
