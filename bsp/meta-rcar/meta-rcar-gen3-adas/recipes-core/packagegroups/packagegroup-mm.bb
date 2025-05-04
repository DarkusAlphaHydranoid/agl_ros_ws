DESCRIPTION = "Multimedia packages"

LICENSE = "BSD-3-Clause & GPL-2.0-or-later & LGPL-2.0-or-later"

inherit packagegroup

PACKAGES = " \
    packagegroup-mm \
"

# Various multimedia packages
RDEPENDS:packagegroup-mm = " \
    gstreamer1.0-plugins-good-pulse \
    pulseaudio-misc \
    pulseaudio-module-cli \
    pulseaudio-module-loopback \
    pulseaudio-module-remap-sink \
    pulseaudio-module-remap-source \
    pulseaudio-server \
"
