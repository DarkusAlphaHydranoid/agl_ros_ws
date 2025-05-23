# Copyright (C) 2018-2022 SanCloud Ltd
# SPDX-License-Identifier: MIT

HOMEPAGE = "http://www.denx.de/wiki/U-Boot/WebHome"
DESCRIPTION = "U-Boot, a boot loader for Embedded boards based on PowerPC, \
ARM, MIPS and several other processors, which can be installed in a boot \
ROM and used to initialize and test the hardware or to download and run \
application code."
SECTION = "bootloaders"
DEPENDS += "flex-native bison-native"

LICENSE = "GPLv2+"
LIC_FILES_CHKSUM = "file://Licenses/README;md5=5a7450c57ffe5ae63fd732446b988025"
PE = "1"

DEPENDS += "flex-native bison-native bc-native dtc-native python3-setuptools-native"

require recipes-bsp/u-boot/u-boot.inc

SRC_URI = "git://github.com/SanCloudLtd/u-boot.git;protocol=https;branch=${BRANCH}"
BRANCH = "uboot-bbe-2022.04"
SRCREV = "e9cce4682f3479f13055f38f16ef92ce84b3c7cb"

S = "${WORKDIR}/git"
B = "${WORKDIR}/build"
do_configure[cleandirs] = "${B}"

PROVIDES += "u-boot"

# Prevent '-bbe' being inserted into to the u-boot-initial-env filename
UBOOT_INITIAL_ENV = "u-boot-initial-env"
