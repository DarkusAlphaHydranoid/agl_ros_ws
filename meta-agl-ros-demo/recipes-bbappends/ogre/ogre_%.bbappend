FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI += " \
    file://jarbay.patch \
    file://egl_fix.patch \
"

EXTRA_OECMAKE_RVIZ_OGRE_VENDOR:append = " -DOGRE_BUILD_COMPONENT_OVERLAY_IMGUI:BOOL=FALSE"

DEPENDS:append = " xserver-xorg"

EXTRA_OECMAKE += " \
    -DOGRE_GLSUPPORT_USE_EGL:BOOL=TRUE \
    -DOGRE_GLSUPPORT_USE_GLX:BOOL=FALSE \
    -DOGRE_USE_WAYLAND:BOOL=TRUE \
"