# meta-rcar-gen3


This layer provides the support for the evaluation board mounted ARM SoCs of
Renesas Electronics, called the R-Car Generation 3.

Currently, this supports boards and the SoCs of the following:

```bash
    - Board: Salvator-X / SoC: R8A77950/R8A77951 (R-Car H3), R8A77960/R8A77961 (R-Car M3), R8A77965 (R-Car M3N)
    - Board: R-Car Starter Kit premier(H3ULCB) / SoC: R8A77950/R8A77951 (R-Car H3)
    - Board: R-Car Starter Kit pro(M3ULCB) / SoC: R8A77960/R8A77961 (R-Car M3)
    - Board: R-Car Starter Kit pro(M3NULCB) / SoC: R8A77965 (R-Car M3N)
    - Board: Ebisu / SoC: R8A77990 (R-Car E3)
    - Board: Draak / SoC: R8A77995 (R-Car D3)
```

## Contribution


* Please submit any patches for this layer to: rcar-yocto@lm.renesas.com

* Please see the MAINTAINERS file for more details.

## Layer Dependencies


This layer depends on:

* poky

```bash
    URI: git://git.yoctoproject.org/poky
    layers: meta, meta-poky, meta-yocto-bsp
    branch: dunfell
```

* meta-openembedded

```bash
    URI: git://git.openembedded.org/meta-openembedded
    layers: meta-oe, meta-python
    branch: dunfell
```

## Build Instructions


The following instructions require a Poky installation (or equivalent).

* This also needs git user name and email defined:

```bash
   $ git config --global user.email "you@example.com"
   $ git config --global user.name "Your Name"
```

* Initialize a build using the 'oe-init-build-env' script in Poky. e.g.:

```bash
    $ source poky/oe-init-build-env
```

* After that, initialized configure bblayers.conf by adding meta-rcar-gen3 layer.
e.g.:

```bash
    BBLAYERS ?= " \
        <path to layer>/poky/meta \
        <path to layer>/poky/meta-poky \
        <path to layer>/poky/meta-yocto-bsp \
        <path to layer>/meta-renesas/meta-rcar-gen3 \
        <path to layer>/meta-openembedded/meta-python \
        <path to layer>/meta-openembedded/meta-oe \
    "
```

* To build a specific target BSP, configure the associated machine in local.conf:

```bash
    MACHINE ??= "<supported board name>"
```

Board|MACHINE
-----|-------
Salvator-X/XS|MACHINE = "salvator-x"
Ebisu|MACHINE = "ebisu"
Starter Kit Pro (M3ULCB)|MACHINE = "m3ulcb"
Starter Kit Pro (M3NULCB)|MACHINE = "m3nulcb"
Starter Kit Premier (H3ULCB)|MACHINE = "h3ulcb"
Draak|MACHINE = "draak"

* Select the SOC

    * For H3: r8a7795

    ```bash
        SOC_FAMILY = "r8a7795"
    ```

    * For M3: r8a7796

    ```bash
        SOC_FAMILY = "r8a7796"
    ```

    * For M3N: r8a77965

    ```bash
        SOC_FAMILY = "r8a77965"
    ```

    * For E3: r8a77990

    ```bash
        # Already added in machine config: ebisu.conf
        SOC_FAMILY = "r8a77990"
    ```

    * For D3: r8a77995

    ```bash
        # Already added in machine config: draak.conf
        SOC_FAMILY = "r8a77995"
    ```

* Configure for systemd init in local.conf:

```bash
    DISTRO_FEATURES:append = " usrmerge systemd"
    VIRTUAL-RUNTIME_init_manager = "systemd"
```

* Configure for ivi-shell and ivi-extension

```bash
    DISTRO_FEATURES:append = " ivi-shell"
```

* Configure for USB 3.0

```bash
    MACHINE_FEATURES:append = " usb3"
```

* Enable tuning support for Capacity Aware migration Strategy (CAS)

```bash
    MACHINE_FEATURES:append = " cas"
```

* For a list of sample local.conf file, please refer to: [docs/sample/conf/](docs/sample/conf/)

* Build the target file system image using bitbake:

```bash
    $ bitbake core-image-minimal
```

After completing the images for the target machine will be available in the
output directory 'tmp/deploy/images/<supported board name>'.

Images generated:

* Image (generic Linux Kernel binary image file)

* \<SoC\>-\<machine name\>.dtb (DTB for target machine)

* core-image-minimal-\<machine name\>.tar.bz2 (rootfs tar+bzip2)

* core-image-minimal-\<machine name\>.ext4  (rootfs ext4 format)

## Build Instructions for SDK


NOTE:

**This may be changed in the near feature. These instructions are tentative.**

Should define the staticdev in SDK image feature for installing the static libs
to SDK in local.conf.

```bash
    SDKIMAGE_FEATURES:append = " staticdev-pkgs"
```

### For 64-bit target SDK (aarch64)


Use `bitbake -c populate_sdk` for generating the toolchain SDK

```bash
    $ bitbake core-image-minimal -c populate_sdk
```

The SDK can be found in the output directory `tmp/deploy/sdk`

* `poky-glibc-x86_64-core-image-minimal-aarch64-<machine name>-toolchain-x.x.sh`

### Usage of toolchain SDK


Install the SDK to the default: `/opt/poky/x.x`

* For 64-bit target SDK

```bash
    $ sh poky-glibc-x86_64-core-image-minimal-aarch64-<machine name>-toolchain-x.x.sh
```

* For 64-bit application, using environment script in `/opt/poky/x.x`

```bash
    $ source /opt/poky/x.x/environment-setup-aarch64-poky-linux
```

## R-Car Generation 3 Information


Refer to the following for more information from eLinux website

https://elinux.org/R-Car
