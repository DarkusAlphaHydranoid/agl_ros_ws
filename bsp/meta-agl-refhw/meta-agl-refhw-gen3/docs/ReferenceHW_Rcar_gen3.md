# Reference Hardware Board

- [About](#about)
- [Difference to Salvator-XS When Flashing Firmware](#difference-to-salvator-xs-when-flashing-firmware)
- [How to Build the Flash Writer](#how-to-build-the-flash-writer)
- [How to Flash Firmware](#how-to-flash-firmware)
- [How to Build the Firmware](#how-to-build-the-firmware)


## About
The AGL Reference hardware board with R-Car H3 SoC is made by Panasonic for the
AGL community.

## Difference to Salvator-XS When Flashing Firmware

The HyperFlash/QSPI flash switch function is not implemented on the reference
hardware board at present, HyperFlash and QSPI flash are not used.  Firmware
(arm-trusted-firmware, U-Boot...) is stored in eMMC and updated by using serial
download.

## How to build the Flash Writer

1. Get the prebuilt cross compiler:
    ```
    $ cd ~/
    $ wget https://releases.linaro.org/components/toolchain/binaries/7.3-2018.05/aarch64-elf/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf.tar.xz
    $ tar xvf gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf.tar.xz
    ```
2. Prepare the source code:
    ```
    $ cd ~/
    $ git clone https://github.com/renesas-rcar/flash_writer.git
    $ cd flash_writer
    $ git checkout rcar_gen3
    ```
3. Build the Flash Writer
    ```
    $ make AArch=64 clean
    $ CROSS_COMPILE=~/gcc-linaro-7.3.1-2018.05-x86_64_aarch64-elf/bin/aarch64-elf- make AArch=64
    ```
    The output image is at:
    ```
    ./AArch64_output/AArch64_Flash_writer_SCIF_DUMMY_CERT_E6300400_salvator-x.mot
    ```


## How to Flash Firmware

1. Connect reference hardware board to the development PC by using USB serial cable.

2. Open a serial console (like Teraterm in Windows, or gtkterm in Ubuntu that
   can easily send files) with a baudrate of 115200n8.

4. Set bit2 of SW2221 (on the top of SoC board) to "off"which turns SW2221 to be
	off,off,off,off.

5. Power on the reference board, you will find following message on the serial
   console:
    ```
    SCIF Download mode (w/o verification)
    (C) Renesas Electronics Corp.

    -- Load Program to SystemRAM ---------------
    please send !
    ```

6. Use console application menu to send the flash writer binary:
    ```
    AArch64_Flash_writer_SCIF_DUMMY_CERT_E6300400_salvator-x.mot
    ```

7. After the writer is transferred correctly, the following message will be displayed:
    ```
    Flash writer for R-Car H3/M3/M3N Series V1.11 Feb.12,2020
    >
    ```
8. Set reference board to boot from eMMC:

    \> **EM_SECSD**  
    Please Input EXT_CSD Index(H'00 - H'1FF) :**b1**  
    EXT_CSD[B1] = 0x00  
    Please Input Value(H'00 - H'FF) :**a**  
    EXT_CSD[B1] = 0x0A  

    \> **EM_SECSD**  
    Please Input EXT_CSD Index(H'00 - H'1FF) :**b3**  
    EXT_CSD[B3] = 0x00  
    Please Input Value(H'00 - H'FF) :**8**  
    EXT_CSD[B3] = 0x08  

    \>**EM_DCSD**  
    [CSD Field Data]  
    [127:126]  CSD_STRUCTURE       0x03  
    [125:122]  SPEC_VERS           0x04  
    [119:112]  TAAC                0x27  
    [111:104]  NSAC                0x01  
    [103: 96]  TRAN_SPEED          0x32  
    [ 95: 84]  CCC                 0x00F5  
    [ 83: 80]  READ_BL_LEN         0x09  
    [ 79: 79]  READ_BL_PARTIAL     0x00  
    [ 78: 78]  WRITE_BLK_MISALIGN  0x00  
    [ 77: 77]  READ_BLK_MISALIGN   0x00  
    [ 76: 76]  DSR_IMP             0x00  
    [ 73: 62]  C_SIZE              0x0FFF  
    [ 61: 59]  VDD_R_CURR_MIN      0x06  
    [ 58: 56]  VDD_R_CURR_MAX      0x06  
    [ 55: 53]  VDD_W_CURR_MIN      0x06  
    [ 52: 50]  VDD_W_CURR_MAX      0x06  
    [ 49: 47]  C_SIZE_MULT         0x07  
    [ 46: 42]  ERASE_GRP_SIZE      0x1F  
    [ 41: 37]  ERASE_GRP_MULT      0x1F  
    [ 36: 32]  WP_GRP_SIZE         0x0F  
    [ 31: 31]  WP_GRP_ENABLE       0x01  
    [ 30: 29]  DEFAULT_ECC         0x00  
    [ 28: 26]  R2W_FACTOR          0x03  
    [ 25: 22]  WRITE_BL_LEN        0x09  
    [ 21: 21]  WRITE_BL_PARTIAL    0x00  
    [ 16: 16]  CONTENT_PROT_APP    0x00  
    [ 15: 15]  FILE_FORMAT_GRP     0x00  
    [ 14: 14]  COPY                0x01  
    [ 13: 13]  PERM_WRITE_PROTECT  0x00  
    [ 12: 12]  TMP_WRITE_PROTECT   0x00  
    [ 11: 10]  FILE_FORMAT         0x00  
    [  9:  8]  ECC                 0x00  
    [  7:  1]  CRC                 0x00  

9. Flash the firmware.

    If using an AGL build with the agl-refhw-h3 feature, you can find the firmware
    files under the build directory in `tmp/deploy/images/h3ulcb`.

    If you use the reference hardware numbered 100 or above,
    please flash the firmware with the suffix "-4x2g-1rank".

    The firmware should be stored on the eMMC as follows:

    | Name                                | eMMC partition | Flash address | Load address | Description
    |-------------------------------------|:--------------:|:-------------:|:------------:|------------------|
    | bootparam_sa0-agl-refhw-4x2g.srec   | 1              | H'000000      | H'E6320000   | Boot parameter
    | bl2-agl-refhw-4x2g.srec             | 1              | H'00001E      | H'E6304000   | bl2 loader
    | cert_header_sa6-agl-refhw-4x2g.srec | 1              | H'000180      | H'E6320000   | Certification
    | bl31-agl-refhw-4x2g.srec            | 1              | H'000200      | H'44000000   | bl3 loader
    | tee-h3ulcb.srec                     | 1              | H'001000      | H'44100000   | OP-Tee
    | u-boot-elf-agl-refhw.srec           | 2              | H'000000      | H'50000000   | U-boot

    If the firmware has been built using a standalone build outside of AGL
    (see [below](#standalone-build)), then the firmware files can be be found in
    `tmp/deploy/images/agl-refhw-h3`, and should be stored on the eMMC as follows:

    | Name                                | eMMC partition | Flash address | Load address | Description
    |-------------------------------------|:--------------:|:-------------:|:------------:|------------------|
    | bootparam_sa0-4x2g.srec             | 1              | H'000000      | H'E6320000   | Boot parameter
    | bl2-agl-refhw-h3-4x2g.srec          | 1              | H'00001E      | H'E6304000   | bl2 loader
    | cert_header_sa6-4x2g.srec           | 1              | H'000180      | H'E6320000   | Certification
    | bl31-agl-refhw-h3-4x2g.srec         | 1              | H'000200      | H'44000000   | bl3 loader
    | tee-agl-refhw-h3.srec               | 1              | H'001000      | H'44100000   | OP-Tee
    | u-boot-elf-salvator-x.srec          | 2              | H'000000      | H'50000000   | U-boot

    The firmware files can be flashed by using **EM_W** command for each of them:

    \> **EM_W**  
    \---------------------------------------------------------  
    Please select,eMMC Partition Area.  
     0:User Partition Area   : 62496768 KBytes  
      eMMC Sector Cnt : H'0 - H'07733FFF  
     1:Boot Partition 1      : 32640 KBytes  
      eMMC Sector Cnt : H'0 - H'0000FEFF  
     2:Boot Partition 2      : 32640 KBytes  
      eMMC Sector Cnt : H'0 - H'0000FEFF  
    \---------------------------------------------------------  
    Select area(0-2)> **\<Enter the eMMC partition number above, Ex.'1' \>**   
    -- Boot Partition X Program -----------------------------  
    Please Input Start Address in sector : **\<Enter the Flash address above, Ex.'1e'\>**  
    Please Input Program Start Address : **\<Enter the Load address above, Ex. 'e6304000'\>**  
    Work RAM(H'50000000-H'50FFFFFF) Clear....  
    please send ! ('.' & CR stop load)  
    **\<Send the fimware file above by using console appliction, Ex. send 'bl2-agl-refhw-x-4x2g.srec'\>**

9. Power off the board.
10. Reset bit2 of SW2221 (on the top of SoC board) to "on", which turns SW2221 to be  
    off,on,off,off.


## How to build the Firmware

### In AGL Build

1. Initialize build environment:
    ```
    source meta-agl/scripts/aglsetup.sh -m h3ulcb agl-refhw-h3
    ```
    or:
    ```
    source meta-agl/scripts/aglsetup.sh -m h3ulcb-nogfx agl-refhw-h3
    ```
2. Build the firmware:
    ```
    bitbake arm-trusted-firmware optee-os u-boot
    ```
3. Afterwards, the firmware files will be in the directory `tmp/deploy/images/agl-refhw-h3`.


### Standalone Build

It is also possible to build the firmware outside of the AGL build by using this
BSP layer on top of the meta-rcar-gen3 layer in meta-renesas.

1. In a temporary working directory, clone poky the poky repository and check out the kirkstone branch:
    ```
    git clone git://git.yoctoproject.org/poky
    cd poky
    git checkout kirkstone
    ..
    ```
2.  Clone the Renesas BSP and it's dependent layers:
    ```
    git clone https://github.com/renesas-rcar/meta-renesas
    cd meta-renesas
    git checkout Renesas-Yocto-v5.5.0
    cd ..
    git clone git://git.openembedded.org/meta-openembedded
    cd meta-openembedded
    git checkout kirkstone
    cd ..
    ```
3. Clone the reference hardware BSP layer:
    ```
    git clone https://gerrit.automotivelinux.org/gerrit/AGL/meta-agl-refhw
    ```
4. Create a build environment:
    ```
    . ./poky/oe-init-build-env build
    ```
5. Add the layers to `conf/bblayers.conf`, the `BBLAYERS` variable definition should look like:
    ```
    BBLAYERS ?= " \
        /home/user/workdir/poky/meta \
        /home/user/workdir/poky/meta-poky \
        /home/user/poky/meta-yocto-bsp \
        /home/user/workdir/meta-openembedded/meta-oe \
        /home/user/workdir/meta-openembedded/meta-python \
        /home/user/workdir/meta-renesas/meta-rcar-gen3 \
        /home/user/workdir/meta-agl-refhw/meta-agl-refhw-gen3 \
    "
    ```
6. Add the machine setting to `conf/local.conf`, for example:
    ```
    echo MACHINE=agl-refhw-h3 >> conf/local.conf
    ```
7. Build the firmware:
    ```
    bitbake arm-trusted-firmware optee-os u-boot
    ```
8. Afterwards, the firmware files will be in the directory `tmp/deploy/images/agl-refhw-h3`.
