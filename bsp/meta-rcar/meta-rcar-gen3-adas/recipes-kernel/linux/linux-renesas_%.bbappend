FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

COMPATIBLE_MACHINE_eagle = "eagle"
COMPATIBLE_MACHINE_v3msk = "v3msk"
COMPATIBLE_MACHINE_condor = "condor"
COMPATIBLE_MACHINE_v3hsk = "v3hsk"

SAFE_RENDERING_SUPPORT = " \
    file://0017-gpio-pca953x-do-not-ignore-i2c-errors.patch \
    file://0145-iio-st_sensors-Call-st_sensors_power_enable-from-bus.patch \
    file://0153-staging-most-dim2-do-not-double-register-the-same-de.patch \
    file://0154-staging-most-dim2-use-device-release-method.patch \
    file://0160-media-i2c-imx219-remove-redundant-writes.patch \
    file://0161-media-i2c-imx219-Split-common-registers-from-mode-ta.patch \
    file://0162-media-i2c-imx219-Fix-binning-for-RAW8-capture.patch \
"


SRC_URI:append = " \
    ${@oe.utils.conditional("DISABLE_RPC_ACCESS", "1", "", " file://hyperflash.cfg", d)} \
    file://nvme.cfg \
    file://imr.cfg \
    file://disable-unused.cfg \
    file://enable.cfg \
    ${@oe.utils.conditional("USE_SAFE_RENDERING", "1", "${SAFE_RENDERING_SUPPORT}", "file://0164-arm64-dts-renesas-Add-ulcb-kf-dtso-files.patch", d)} \
    file://renesas.scc \
"

SRC_URI:append:ulcb = " \
    file://ulcb.cfg \
    file://ath9k_wireless_pcie.cfg \
"

SRC_URI:append:salvator-x = " file://salvator-x.cfg"

SRC_URI:append:rcar-gen3-v3x = " \
    file://v3x.cfg \
    file://cma.cfg \
    ${@oe.utils.conditional("DISABLE_RPC_ACCESS", "1", "", " file://qspi.cfg", d)} \
"

ULCB_KF_DTBO = " \
    renesas/ulcb-kf-panel-mitsubishi-aa104xd12-1024x768.dtbo \
    renesas/ulcb-kf-panel-mitsubishi-aa121td01-1280x800.dtbo \
    renesas/ulcb-kf-panel-koe-tx31d200vm0baa-1280x480.dtbo \
    renesas/ulcb-kf-cn10-gmsl2.dtbo \
    renesas/ulcb-kf-cn10-pca.dtbo \
    renesas/ulcb-kf-cn11.dtbo \
    renesas/ulcb-kf-cn11-gmsl2.dtbo \
    renesas/ulcb-kf-cn11-pca.dtbo \
    renesas/ulcb-kf-most.dtbo \
    renesas/ulcb-kf-sd3.dtbo \
    renesas/ulcb-kf-imx219.dtbo \
"

KERNEL_DEVICETREE:append:h3ulcb = " \
    renesas/r8a77951-ulcb-kf.dtb \
    renesas/r8a779m1-ulcb-kf.dtb \
    ${ULCB_KF_DTBO} \
"

KERNEL_DEVICETREE:append:m3ulcb = " \
    renesas/r8a77960-ulcb-kf.dtb \
    renesas/r8a77961-ulcb-kf.dtb \
    ${ULCB_KF_DTBO} \
"

KERNEL_DEVICETREE:append:m3nulcb = " \
    renesas/r8a77965-ulcb-kf.dtb \
    ${ULCB_KF_DTBO} \
"

KERNEL_DEVICETREE:append:rcar-gen3-v3x = " \
    renesas/r8a77970-es1-eagle.dtb \
    renesas/r8a77970-es1-eagle-function.dtb \
    renesas/r8a77970-es1-v3msk.dtb \
    renesas/r8a77970-es1-v3msk-vbm-v2.dtb \
    renesas/r8a77970-es1-v3msk-vbm-v3.dtb \
    renesas/r8a77970-es1-v3msk-vbm.dtb \
    renesas/r8a77970-es1-v3msk-view.dtb \
    renesas/r8a77970-eagle.dtb \
    renesas/r8a77970-eagle-function.dtb \
    renesas/r8a77970-v3msk.dtb \
    renesas/r8a77970-v3msk-vbm-v2.dtb \
    renesas/r8a77970-v3msk-vbm-v3.dtb \
    renesas/r8a77970-v3msk-vbm.dtb \
    renesas/r8a77970-v3msk-view.dtb \
    renesas/r8a77980-condor.dtb \
    renesas/r8a77980-v3hsk.dtb \
    renesas/r8a77980-es2-condor.dtb \
    renesas/r8a77980-es2-v3hsk.dtb \
    renesas/r8a77980-v3hsk-vb-4ch.dtb \
    renesas/r8a77980-v3hsk-vb-8ch.dtb \
    renesas/r8a77980-v3hsk-vb-gmsl-8ch.dtb \
    renesas/r8a77980-v3hsk-vb-gmsl2-4.dtb \
    renesas/r8a77980-v3hsk-vb-gmsl2-8.dtb \
    renesas/r8a77980-es2-v3hsk-vb-4ch.dtb \
    renesas/r8a77980-es2-v3hsk-vb-8ch.dtb \
    renesas/r8a77980-es2-v3hsk-vb-gmsl-8ch.dtb \
    renesas/r8a77980-es2-v3hsk-vb-gmsl2-4.dtb \
    renesas/r8a77980-es2-v3hsk-vb-gmsl2-8.dtb \
"

# Prefer generic-uio driver over kernel drivers
KERNEL_MODULE_PROBECONF:append = " rcar_imr"
KERNEL_MODULE_PROBECONF:append = " rcar_csi2"
KERNEL_MODULE_PROBECONF:append = " rcar_vin"
KERNEL_MODULE_PROBECONF:append = " vsp1"
KERNEL_MODULE_PROBECONF:append = " rcar-du-drm"
KERNEL_MODULE_PROBECONF:append = " rcar_lvds"
module_conf_rcar_imr = "blacklist rcar_imr"
module_conf_rcar_csi2 = "blacklist rcar_csi2"
module_conf_rcar_vin = "blacklist rcar_vin"
module_conf_vsp1 = "blacklist vsp1"
module_conf_rcar-du-drm = "blacklist rcar-du-drm"
module_conf_rcar_lvds = "blacklist rcar_lvds"

KERNEL_MODULE_AUTOLOAD:append = " uio_pdrv_genirq"
KERNEL_MODULE_PROBECONF:append = " uio_pdrv_genirq"
module_conf_uio_pdrv_genirq:append = 'options uio_pdrv_genirq of_id="generic-uio"'

# Install RCAR Gen3 specific UAPI headers
do_install:append:rcar-gen3() {
    install -d ${D}/usr/include/linux/
    install -m 0644 ${STAGING_KERNEL_DIR}/include/uapi/linux/rcar-imr.h ${D}/usr/include/linux/
}

PACKAGES += "${PN}-uapi"
FILES:${PN}-uapi = "/usr/include"
