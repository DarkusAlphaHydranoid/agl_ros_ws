FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI:append = " \
    file://0002-configs-rcar-gen3-Enable-askenv-command.patch \
    file://0003-net-sh_eth-Toggle-PHY-GPIO-reset-pin.patch \
    file://0004-clk-renesas-cpg-Update-SD-IF-clock-handling.patch \
    file://0005-clk-renesas-r8a77970-cpg-mssr-Fix-SD-clock.patch \
    file://0006-clk-renesas-clk-rcar-gen3-Fix-SD-divider-setting.patch \
    file://0007-ARM-dts-r8a77970-eagle-Add-eMMC-support.patch \
    file://0008-configs-r8a77970-Eagle-Enable-MMC-support-by-default.patch \
    file://0009-ARM-dts-r8a77970-Eagle-Add-RAVB-PHY-GPIO-reset-pin.patch \
    file://0011-mmc-renesas_sdhi-Add-R-Car-V3H-support.patch \
    file://0012-configs-r8a77980-Condor-Enable-MMC-support-by-defaul.patch \
    file://0013-ARM-rmobile-Add-R8A77970-V3MSK-board-support.patch \
    file://0014-ARM-rmobile-Add-R8A77980-V3HSK-board-support.patch \
    file://0015-arm-renesas-v3msk-Add-CPLD-support.patch \
    file://0016-arm-renesas-v3hsk-Add-CPLD-support.patch \
    file://0018-net-sh_eth-Workaround-cache-issues.patch \
    file://0019-net-sh_eth-Fix-RX-error-handling.patch \
    file://0020-arm-renesas-Enable-RPC-HF-MTD-support-for-all-ULCB-b.patch \
    file://0021-arm-renesas-Enable-RPC-HF-MTD-support-for-all-Salvat.patch \
    ${@oe.utils.conditional("DISABLE_RPC_ACCESS", "1", "file://0022-arm-dts-renesas-Disable-RPC-on-all-boards.patch", "", d)} \
"
