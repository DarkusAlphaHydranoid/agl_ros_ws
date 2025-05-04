FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append = " \
	file://0001-Create-r8a7795-USB-OVC-pin-groups.patch \
	file://0002-Add-AGL-reference-hardware-support.patch \
	file://0003-Add-support-for-TI-WL1837.patch \
	file://0004-Mute-CEC-IRQ-in-dw-hdmi-driver-init.patch \
	file://refhw-rcar.cfg \
"

KERNEL_CONFIG_FRAGMENTS:append = " ${WORKDIR}/refhw-rcar.cfg"
