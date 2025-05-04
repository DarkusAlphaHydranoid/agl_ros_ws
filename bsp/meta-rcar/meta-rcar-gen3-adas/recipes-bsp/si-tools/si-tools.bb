SUMMARY = "Tools for si46xx AM/FM/DAB radio chip"
SECTION = "multimedia"

LICENSE = "CLOSED"

INSANE_SKIP:${PN} = "ldflags"
INSANE_SKIP:${PN}-dev = "ldflags"

PE = "1"
PV = "0.2"

SRC_URI = " \
    file://si-tools.tar.gz \
    file://si46xx_flash_write_typo_fix.patch \
    file://scripts_si_scan_fix_xdg_runtime_dir_warning.patch \
"

S = "${WORKDIR}/si-tools"

SCRIPTS = "si_init si_firmware_update si_fm si_preset si_scan"
FIRMWARE = "am.bif fm.bif dab.bif patch.bin"

do_install() {
    install -d ${D}${bindir}
    install -d ${D}${nonarch_base_libdir}/firmware/radio/

    install -m 755 si_ctl ${D}${bindir}
    install -m 755 si_flash ${D}${bindir}
    for file in ${SCRIPTS}; do
        install -m 755 ${S}/scripts/$file ${D}${bindir}
        sed -e 's,^\(SI_ARGS\s*=\s*\).*,\1"/dev/i2c-12 0x65",' -i ${D}${bindir}/$file
    done

    for file in ${FIRMWARE}; do
        install -m 644 ${S}/firmware/$file ${D}${nonarch_base_libdir}/firmware/radio/
    done
}

FILES:${PN} = " \
    ${bindir} \
    ${nonarch_base_libdir}/firmware/radio \
"
