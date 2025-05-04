SUMMARY = "CTemplate is a simple but powerful template language for C++. It emphasizes separating logic from presentation: it is impossible to embed application logic in this template language."
HOMEPAGE = "https://code.google.com/p/ctemplate/"
LICENSE = "GOOGLE-NEW-BSD"
SECTION = "libs"

inherit autotools pkgconfig

LIC_FILES_CHKSUM = "file://COPYING;md5=762732742c73dc6c7fbe8632f06c059a"

BBCLASSEXTEND = "native nativesdk"

RDEPENDS:${PN} += "perl"

SRC_URI:append = " file://0001-Update-python-scripts-to-python3.patch"
