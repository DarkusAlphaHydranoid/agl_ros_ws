# NanoPC-T6 kernel support
FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:nanopct6 = " \
    git://github.com/friendlyarm/kernel-rockchip.git;protocol=https;nobranch=1;branch=nanopi5-v5.10.y_opt; \
    file://cgroups.cfg \
    file://rtw88.cfg \
    file://network-option.cfg \
    file://hid-option.cfg \
"
SRCREV:nanopct6 = "83ad55ea02e284cb96b49df7eda89dc6797d9d9c"

