# require recipes-platform/images/agl-ivi-demo-qt.bb
require recipes-platform/images/agl-image-weston.bb

AGL_APPS_INSTALL += " \
    agl-shell-activator \
"

IMAGE_INSTALL:append = " \
    ros-core \
    python3-core \
    rviz2 \
    weston-ini-conf-landscape \
    qtbase \
    qtbase-dev \
    qtbase-plugins \
    qtbase-staticdev \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-qmlplugins \
    qtdeclarative-tools \
    qtcharts \
    qtwayland \
    qtwayland-plugins \
    qtwayland-tools \
    qtgraphicaleffects-qmlplugins \
    qtvirtualkeyboard \
    python3-pyqt5 \
    xserver-xorg-extension-glx \
    mesa-demos \
    kmscube \
    lshw \
    xterm \
"


RDEPENDS:${PN} += "\
    qtbase \
    qtbase-dev \
    qtbase-plugins \
    qtbase-staticdev \
    qtbase-tools \
    qtdeclarative \
    qtdeclarative-qmlplugins \
    qtdeclarative-tools \
    qtcharts \
    qtwayland \
    qtwayland-plugins \
    qtwayland-tools \
    qtgraphicaleffects-qmlplugins \
    qtvirtualkeyboard \
    "