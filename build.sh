#!/bin/bash

# LOGS
LOG_FILE="build_logs.txt"
BUILD_START=$(date +"%s")

# Colors
blue='\033[0;34m'
cyan='\033[0;36m'
yellow='\033[0;33m'
red='\033[0;31m'
nocol='\033[0m'

echo -e "${red}====================="
echo "   Mirandas Kernel"
echo -e "=====================${nocol}\n"
sleep 1

#Set Configs
ROOTDIR="$(pwd)"
DEFCONFIG="vendor/sweet_defconfig"

# Export
echo "Exporting..."
export ARCH=arm64
export SUBARCH=arm64
export CLANG_PATH="$ROOTDIR/clang"
export GCC64_PATH="$ROOTDIR/gcc64"
export GCC32_PATH="$ROOTDIR/gcc32"
export PATH="$CLANG_PATH/bin:$GCC64_PATH/bin:$GCC32_PATH/bin:$PATH"
export KBUILD_BUILD_USER="Llorens"
export KBUILD_BUILD_HOST="MKernel"
sleep 0.5
# Clean

echo "Cleaning..."
rm -rf out
echo ""

sleep 0.5
echo -e "${blue}************************************"
echo "          BUILDING KERNEL          "
echo -e "************************************${nocol}"

make O=out ARCH=arm64 "$DEFCONFIG"
make -j"$(nproc)" \
    O=out \
    ARCH=arm64 \
    LLVM=1 \
    LLVM_IAS=1 \
    CC=clang \
    CLANG_TRIPLE=aarch64-linux-gnu- \
    CROSS_COMPILE=aarch64-elf- \
    CROSS_COMPILE_ARM32=arm-eabi- \
    2>&1 | tee -a "$LOG_FILE"

# Check to stop the script if the kernel did not compile
if [ ! -f "$PWD/out/arch/arm64/boot/Image.gz" ]; then
    echo -e "\n${red}ERROR: Kernel compilation failed!${nocol}"
    exit 1
fi

# Prepare AnyKernel3
echo "Preparing AnyKernel3..."
cp out/arch/arm64/boot/Image.gz AnyKernel3/
cp out/arch/arm64/boot/dtb.img AnyKernel3/
cp out/arch/arm64/boot/dtbo.img AnyKernel3/
echo ""

# Create Flashable ZIP
echo "Creating flashable zip..."
(
cd AnyKernel3
zip -r9 "../MKernel.zip" *

echo ""

# End compilation Dates
BUILD_END=$(date +"%s")
DIFF=$((BUILD_END - BUILD_START))
echo -e "${yellow}Build completed in $((DIFF / 60)) minute(s) and $((DIFF % 60)) seconds.${nocol}"
echo "Completed"
