DISTRO_FEATURES:append = " x11 opengl vulkan polkit wayland glx glamor xcb"
# IMAGE_FEATURES:append = " x11"
# IMAGE_FEATURES:append = " x11 weston"
PACKAGECONFIG:append:pn-clang = "  libomp"
PACKAGECONFIG:append:pn-qtbase-native = " gui"
PACKAGECONFIG:append:pn-python3 = "  tk"
PACKAGECONFIG:append:pn-mesa = " glvnd"

PACKAGE_CLASSES = "package_deb"