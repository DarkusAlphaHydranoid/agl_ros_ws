DESCRIPTION = "V3X specific packages"

LICENSE = "BSD-3-Clause & GPL-2.0-or-later & LGPL-2.0-or-later"

inherit packagegroup

PACKAGES = " \
    packagegroup-v3x \
    packagegroup-v3x-test \
"

# V3x common packages: IMP UIO, CMEM, CV lib, ICCOM
RDEPENDS:packagegroup-v3x = " \
    kernel-module-cmemdrv \
    kernel-module-iccom \
    libiccom \
    udev-rules-cvlib \
"

# V3x test and benchmark packages
RDEPENDS:packagegroup-v3x-test = " \
    br-test \
    dbench \
    tbench \
    dhrystone \
    ${@bb.utils.contains("LICENSE_FLAGS_WHITELIST", "non-commercial", "netperf", "", d)} \
    whetstone \
"
