# NanoPC-T6 kernel support
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:nanopct6 = " \
    git://github.com/friendlyarm/kernel-rockchip.git;protocol=https;nobranch=1;branch=nanopi6-v6.1.y; \
    file://cgroups.cfg \
    file://rtw88.cfg \
    file://network-option.cfg \
    file://hid-option.cfg \
    file://rockchip-can.cfg \
"

SRCREV:nanopct6 = "d71ee263033d23540b9225bfa42909dfba09216e"

do_compile:prepend() {
    mkdir -p ${B}/drivers/gpu/arm/bifrost/
    cp ${S}/drivers/gpu/arm/bifrost/mali_csffw.bin ${B}/drivers/gpu/arm/bifrost/mali_csffw.bin
}
