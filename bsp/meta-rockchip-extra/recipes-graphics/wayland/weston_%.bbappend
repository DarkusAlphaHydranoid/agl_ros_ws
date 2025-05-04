FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0001-HACK-gl-renderer-Fallback-to-GBM-when-surfaceless-pl.patch \
    file://0004-backend-drm-Cleanup-output-s-disable-head-list-when-.patch \
    file://0005-gl-renderer-Force-using-GL_TEXTURE_EXTERNAL_OES-for-.patch \
    file://0006-backend-drm-Bind-the-Nth-primary-and-cursor-plane-to.patch \
    file://weston-rockchip.conf \
    "

do_install:append() {
    # Install systemd service drop-in with extra configuration
    install -d ${D}${systemd_system_unitdir}/weston.service.d
    install -m644 ${WORKDIR}/weston-rockchip.conf ${D}/${systemd_system_unitdir}/weston.service.d/weston-rockchip.conf
}

FILES:${PN}:append = " \
    ${systemd_system_unitdir}/weston.service.d/weston-rockchip.conf \
    "
