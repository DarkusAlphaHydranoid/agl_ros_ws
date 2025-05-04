FILESEXTRAPATHS:prepend := "${THISDIR}/files:"

SRC_URI:append:rcar-gen3 = " file://0001-rcar_gen3-plat-Do-not-panic-on-unrecognized-boards.patch"

# Since it is believed the eMMC configuration below makes the result
# AGL reference hardware specific, mark it as such when building with
# MACHINE=agl-refhw-h3 to potentially flag this in an incorrectly
# configured build.
COMPATIBLE_MACHINE:agl-refhw-h3 = "agl-refhw-h3"

# There are hardware issues in using hyperflash. arm-trusted-firmware, optee and
# u-boot have to be stored into eMMC by using serial download.
# We need to specify it explicitly for the reference hardware configs when
# building with MACHINE=h3ulcb to not break the h3ulcb builds.
REFHW_ATFW_OPT_BOOTMODE = "RCAR_SA6_TYPE=1"

# Use the existing bootmode flag with MACHINE=agl-refhw-h3
USE_EMMC_BOOTMODE:agl-refh-h3 = "1"

# RCAR_DRAM_MEMRANK must be set, since in case of RCAR_DRAM_LPDDR4_MEMCONF=1
# ddr_rank_judge is called. But for RCAR_DRAM_MEMRANK=0 it can determine values
# only for Salvator XS and Starter Kit Pre.
#
# RCAR_DRAM_MEMRANK=2 is set because for ATF from BSP v4.7.0:
#
# https://github.com/renesas-rcar/arm-trusted-firmware/tree/af9f429a48b438e314289f17947ad5d8036f398e
#
# _board_judge returns hardcoded 'brd = 8;  /*  8Gbit/2rank */' by default.
#
DDR_8G_OPTION = "RCAR_DRAM_LPDDR4_MEMCONF=1 RCAR_DRAM_MEMRANK=2"

# AGL reference hardware numbered 100 or above has 16Gbit/1rank DRAM
# and please flash the firmware built with the following options.
DDR_8G_1RANK_OPTION = "RCAR_DRAM_LPDDR4_MEMCONF=1 RCAR_DRAM_MEMRANK=1"

#
# Build configurations for MACHINE=agl-refhw-h3, derived from salvator_x_r8a7795
#

agl_refhw_h3_r8a7795[4x2g]       = "LSI=H3 RCAR_DRAM_SPLIT=1 ${ATFW_OPT_LOSSY} ${ATFW_OPT_BOOTMODE} ${DDR_8G_OPTION}"
agl_refhw_h3_r8a7795[4x2g-1rank] = "LSI=H3 RCAR_DRAM_SPLIT=1 ${ATFW_OPT_LOSSY} ${ATFW_OPT_BOOTMODE} ${DDR_8G_1RANK_OPTION}"

#
# Extra configurations for building as extra firmware with MACHINE=h3ulcb
#

h3ulcb_r8a7795[agl-refhw-4x2g]       = "LSI=H3 RCAR_DRAM_SPLIT=1 ${ATFW_OPT_LOSSY} ${REFHW_ATFW_OPT_BOOTMODE} ${DDR_8G_OPTION}"
h3ulcb_r8a7795[agl-refhw-4x2g-1rank] = "LSI=H3 RCAR_DRAM_SPLIT=1 ${ATFW_OPT_LOSSY} ${REFHW_ATFW_OPT_BOOTMODE} ${DDR_8G_1RANK_OPTION}"

# Boot Normal World in EL2: this define configures ATF (SPSR register) to boot
# BL33 in EL2.
EXTRA_OEMAKE += " RCAR_BL33_EXECUTION_EL=1"

# Hook to rename firmware files when building with MACHINE=h3ulcb
# to hopefully avoid confusion.

do_refhw_fixup() {
    # Rename agl-refhw-h3 firmware files to drop h3ulcb-
    for f in ${S}/release/*-h3ulcb-agl-refhw-4x2g*; do
        n=`basename $f | sed 's/h3ulcb-//'`
        mv -f $f ${S}/release/$n
    done
}

DO_COMPILE_POSTFUNCS = ""
DO_COMPILE_POSTFUNCS:h3ulcb = "do_refhw_fixup"
do_compile[postfuncs] += "${DO_COMPILE_POSTFUNCS}"
