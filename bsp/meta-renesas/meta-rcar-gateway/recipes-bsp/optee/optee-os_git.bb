DESCRIPTION = "OP-TEE OS"

LICENSE = "BSD-2-Clause & BSD-3-Clause"
LIC_FILES_CHKSUM = " \
    file://LICENSE;md5=c1f21c4f72f372ef38a5a4aee55ec173 \
"

PACKAGE_ARCH = "${MACHINE_ARCH}"

inherit deploy python3native

PV = "3.13+renesas+git${SRCPV}"

BRANCH = "rcar-gen4_3.13"
SRCREV = "6f9792db6411d6c172077eb28e584ab5f46a174e"

SRC_URI = " \
    git://github.com/renesas-rcar/optee_os.git;branch=${BRANCH};protocol=https \
    file://0001-Makefile-Disable-linker-warning.patch \
"

COMPATIBLE_MACHINE = "(spider|s4sk)"
PLATFORM = "rcar_gen4"

DEPENDS = "python3-pycryptodome-native python3-pyelftools-native"

export CROSS_COMPILE64="${TARGET_PREFIX}"

# Let the Makefile handle setting up the flags as it is a standalone application
#LD[unexport] = "1"
LDFLAGS[unexport] = "1"
libdir[unexport] = "1"

S = "${WORKDIR}/git"
EXTRA_OEMAKE = "-e MAKEFLAGS="

do_compile() {
    oe_runmake PLATFORM=${PLATFORM}
}

# do_install() nothing
do_install[noexec] = "1"

do_deploy() {
    # Create deploy folder
    install -d ${DEPLOYDIR}

    # Copy TEE OS to deploy folder
    install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee.elf ${DEPLOYDIR}/tee-${MACHINE}.elf
    install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee-raw.bin ${DEPLOYDIR}/tee-${MACHINE}.bin
    install -m 0644 ${S}/out/arm-plat-${PLATFORM}/core/tee.srec ${DEPLOYDIR}/tee-${MACHINE}.srec
}

addtask deploy before do_build after do_compile

