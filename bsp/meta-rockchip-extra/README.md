# Extend yocto bsp layer for NanoPC-T6 board

This layer provides support for NanoPC-T6 board for use with
OpenEmbedded and/or Yocto.
This layer extend meta-rockchip to support NanoPC-T6 board.
It focused to AGL support.

Layer maintainer: Naoto Yamaguchi <naoto.yamaguchi@automotivelinux.org>

## Tested board configuration

This layer tested by:
   - Memory   16GB (4GB/8GB was not tested)
   - eMMC     256GB(:0GB/32GB/64GB was not tested)
   - WIFI/BT  RTL8822CE M2 module
