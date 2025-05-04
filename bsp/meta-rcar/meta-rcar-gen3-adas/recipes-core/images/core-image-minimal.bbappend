COMPATIBLE_MACHINE_eagle = "eagle"
COMPATIBLE_MACHINE_v3msk = "v3msk"
COMPATIBLE_MACHINE_condor = "condor"
COMPATIBLE_MACHINE_v3mzf = "v3mzf"
COMPATIBLE_MACHINE_v3hsk = "v3hsk"

IMAGE_INSTALL:append = " \
    ${@bb.utils.contains('DISTRO_FEATURES', "bsp-pkgs", "packagegroup-bsp", "", d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', "opencv-sdk", "packagegroup-opencv-sdk", "", d)} \
    ${@bb.utils.contains('DISTRO_FEATURES', "surroundview", "packagegroup-surroundview-drm", "", d)} \
"

IMAGE_INSTALL:append:rcar-gen3-v3x = " \
    packagegroup-v3x \
    packagegroup-v3x-test \
"
