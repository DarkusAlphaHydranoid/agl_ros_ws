# NanoPC-T6 support
FILESEXTRAPATHS:prepend := "${THISDIR}/u-boot-nanopct6:"

SRCREV:nanopct6 = "1b1171b7c71671033a0d6e359c74efcea775f096"
SRCREV_rkbin:nanopct6 = "f02d10e468d8c783c45137d230ff33d42ca670b4"
SRC_URI:nanopct6 = " \
    git://github.com/friendlyarm/uboot-rockchip.git;protocol=https;branch=nanopi6-v2017.09; \
    git://github.com/friendlyarm/rkbin.git;protocol=https;branch=nanopi6;name=rkbin;destsuffix=rkbin; \
    file://0001-Change-default-bootargs.patch \
    file://0002-Disable-android-avb.patch \
"

PATCHPATH = ""
