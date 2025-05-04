CXXFLAGS += "-Wno-float-equal"

# DEPENDS += "python3-pybind11-native"
# 
# EXTRA_OECMAKE += "\
#   -DCMAKE_VERBOSE_MAKEFILE=ON \
# "

FILESEXTRAPATHS:prepend := "${THISDIR}/patches:"

SRC_URI += " \
    file://py_version.patch \
"

OECMAKE_FIND_ROOT_PATH_MODE_PROGRAM = "BOTH"