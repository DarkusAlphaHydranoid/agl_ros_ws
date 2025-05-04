DESCRIPTION = "BSP packages (explicitly requested by Renesas)"

LICENSE = "BSD-3-Clause & GPL-2.0-or-later & LGPL-2.0-or-later"

PACKAGE_ARCH = "${TUNE_PKGARCH}"

inherit packagegroup

PACKAGES = " \
    packagegroup-bsp-core \
    packagegroup-bsp-custom \
    packagegroup-bsp-devdbg \
    packagegroup-bsp-utest \
    packagegroup-bsp \
"

PACKAGES:append:rcar-gen3-v3x = " \
    packagegroup-bsp-python3 \
"

RDEPENDS:packagegroup-bsp = " \
    packagegroup-bsp-core \
    packagegroup-bsp-custom \
    packagegroup-bsp-devdbg \
    packagegroup-bsp-utest \
"

RDEPENDS:packagegroup-bsp:append:rcar-gen3-v3x = " \
    packagegroup-bsp-python3 \
"

# Packages mandatory for BSP (but often not needed)
RDEPENDS:packagegroup-bsp-core = " \
    cmake \
    g++ \
    gcc \
    git \
    git-perltools \
    make \
"

# Packages mandatory for BSP (useful for development/debug)
RDEPENDS:packagegroup-bsp-devdbg = " \
    atop \
    curl \
    devmem2 \
    gdb \
    gdbserver \
    iperf3 \
    iproute2 \
    iproute2-tc \
    linuxptp \
    nano \
    openssh \
    openssh-sftp \
    openssh-sftp-server \
    opkg \
    perf \
    procps \
    strace \
    vim \
    wget \
"

# Various packages needed for all boards
RDEPENDS:packagegroup-bsp-custom = " \
    bonnie++ \
    can-utils \
    capture \
    media-ctl \
    e2fsprogs \
    e2fsprogs-tune2fs \
    e2fsprogs-resize2fs \
    eglibc-utils \
    ethtool \
    iio-utils \
    kernel-devicetree \
    kernel-modules \
    ldd \
    libpcap \
    libsocketcan \
    lmbench \
    most-tools \
    mtd-utils \
    pciutils \
    rsync \
    spidev-dbg spidev-test \
    subversion \
    usbutils \
    util-linux \
    v4l2-fw \
    ${@bb.utils.contains("IMAGE_FEATURES", "ssh-server-openssh", "", "dropbear",d)} \
"

# Python2 packages requested by Renesas
#RDEPENDS:packagegroup-bsp-python2 = " \
#    python-dbus \
#    python-nose \
#    python-numpy \
#    python-pygobject \
#    python-pyyaml \
#    python-setuptools \
#"
# Python3 packages requested by Renesas
RDEPENDS:packagegroup-bsp-python3 = " \
    python3-dbus \
    python3-nose \
    python3-numpy \
    python3-pygobject \
    python3-pyyaml \
    python3-setuptools \
"


# Utest (IMR, IMP, etc demos) related packages
RDEPENDS:packagegroup-bsp-utest = " \
    gstreamer1.0-plugins-base \
    gstreamer1.0-plugins-base-app \
    kernel-module-mmngr \
    kernel-module-mmngrbuf \
    libdrm \
    libgstallocators-1.0 \
    libgstapp-1.0 \
    libinput \
    libyaml \
    linux-renesas-uapi \
    mmngr-user-module \
    netevent \
    utest-cam-imr-drm \
"
