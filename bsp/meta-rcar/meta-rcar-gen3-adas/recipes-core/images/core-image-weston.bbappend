IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', "pulseaudio", "packagegroup-mm", "", d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', "bluetooth", "packagegroup-radio", "", d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', "bsp-pkgs", "packagegroup-bsp", "", d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', "opencv-sdk", "packagegroup-opencv-sdk", "", d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', "surroundview", "packagegroup-surroundview", "", d)} \
"

# CONFLICT_DISTRO_FEATURES = "x11"
