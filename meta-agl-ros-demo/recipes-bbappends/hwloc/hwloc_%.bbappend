EXTRA_OECONF = "--disable-cuda"

DEPENDS += "ocl-icd"
RDEPENDS:${PN} += "ocl-icd"
# RDEPENDS:${PN}:remove = "libcudart.so.12()(64bit)"