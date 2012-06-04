#!/bin/bash

rm META-INF/com/google/android/updater-script

echo '
ui_print("Now installing:");
ui_print("'$1'");
ui_print("by pax0r");
ui_print("extracting system...");
set_progress(1.0);
mount("yaffs2", "MTD", "system", "/system");
package_extract_dir("system", "/system");
unmount("/system");
ui_print("extracting kernel...");
package_extract_dir("kernel", "/tmp");
ui_print("update boot image...");
set_perm(0, 0, 0777, "/tmp/dump_image");
set_perm(0, 0, 0777, "/tmp/mkbootimg.sh");
set_perm(0, 0, 0777, "/tmp/mkbootimg");
set_perm(0, 0, 0777, "/tmp/unpackbootimg");
run_program("/tmp/dump_image", "boot", "/tmp/boot.img");
run_program("/tmp/unpackbootimg", "/tmp/boot.img", "/tmp/");
run_program("/tmp/mkbootimg.sh");
write_raw_image("/tmp/newboot.img", "boot");
ui_print("done.");
' > META-INF/com/google/android/updater-script

cp ~/pecan_kernel_32/drivers/net/wireless/bcm4329/wireless.ko system/lib/modules/wireless.ko 
cp ~/pecan_kernel_32/drivers/net/tun.ko system/lib/modules/tun.ko
cp ~/pecan_kernel_32/arch/arm/boot/zImage kernel/zImage 
rm kernel.zip 
zip -r kernel.zip .
