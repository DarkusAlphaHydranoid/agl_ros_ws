do_install:append:rcar-v4x () {
    if [ ! -z "${SERIAL_CONSOLES}" ]; then
        sed -i -e "s/$default_baudrate/--keep-baud/" ${D}${systemd_unitdir}/system/serial-getty@.service
    fi
}
