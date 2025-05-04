# FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"
# 
# IMAGE_FEATURES += "accessibility"
# IMAGE_FEATURES += "gles2 mtdev sql-sqlite glib fontconfig gif accessibility xcb egl libs xkb xkmcommon"
# QT_CONFIG_FLAGS_APPEND = "-xcb"
# 
# PACKAGECONFIG:append = " widgets"
# 
# DEPENDS += "gsl libxkbcommon"
# 
# RDEPENDS_${PN} += "gsl xrandr libxkbcommon"
# 
# do_configure:prepend () {
#     # the below indentation is important - Soham
#     cat > ${S}/mkspecs/oe-device-extra.pri <<EOF
# 
# QMAKE_LIBS_EGL += -lEGL -ldl -lglib-2.0 -lpthread -lX11 -lxcb -lXrandr -lxcb-glx
# QMAKE_LIBS_OPENGL_ES2 += -lGLESv2 -lgsl -lEGL -ldl -lglib-2.0 -lpthread -lX11 -lxcb -lXrandr -lxcb-glx
# 
# QMAKE_CFLAGS += -DLINUX=1 -DWL_EGL_PLATFORM -DEGL_API_FB=1 -DXCB_USE_EGL -DXCB_USE_GLX
# QMAKE_CXXFLAGS += -DLINUX=1 -DWL_EGL_PLATFORM -DEGL_API_FB=1 -DXCB_USE_EGL -DXCB_USE_GLX
# 
# QT_QPA_DEFAULT_PLATFORM = xcb
# QT_XCB_GL_INTEGRATION = xcb_egl
# 
# EOF
# }

# PACKAGECONFIG:remove:pn-qtwayland = "xcomposite-glx"