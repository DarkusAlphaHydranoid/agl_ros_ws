require rcar-image-minimal.bb

IMAGE_FEATURES += " \
    dev-pkgs \
    tools-sdk \
    tools-profile \
    tools-debug \
    ssh-server-openssh \
"

# Packages for Gateway platform
IMAGE_INSTALL:append = " \
    kernel-module-uio-pdrv-genirq \
    kernel-module-cmemdrv \
    kernel-module-cmemdrv-dev \
    kernel-firmware-r8a779f0-ufs \
    udev-rules \
    packagegroup-oss \
    kernel-devicetree \
    kernel-modules \
    linux-renesas-uapi \
    kernel-module-qos \
    qosif-user-module \
    qosif-tp-user-module \
    pcie-test \
    nvme-initscripts \
"
