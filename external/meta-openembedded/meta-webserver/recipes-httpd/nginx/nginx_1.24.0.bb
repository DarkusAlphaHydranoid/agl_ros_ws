require nginx.inc

LIC_FILES_CHKSUM = "file://LICENSE;md5=175abb631c799f54573dc481454c8632"

SRC_URI:append = " file://CVE-2023-44487.patch \
                   file://CVE-2025-23419.patch"

SRC_URI[sha256sum] = "77a2541637b92a621e3ee76776c8b7b40cf6d707e69ba53a940283e30ff2f55d"

