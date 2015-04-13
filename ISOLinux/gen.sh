#!/bin/bash
#genisoimage -o MyOS.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot -boot-load-size 4 -boot-info-table   ISO/
genisoimage -o MyOS.iso -b isolinux/isolinux.bin -c isolinux/boot.cat -no-emul-boot  -boot-info-table   ISO/
