#!/bin/bash
#set -e
#By Ll0rens

echo ""
echo "=========================="
echo "  Cloning toolchains..."
echo "=========================="
echo ""
sleep 1

################################
# Toolchains
################################

# AnyKernel3 only if it does not exist
if [ ! -d "AnyKernel3" ]; then
    echo "Cloning AnyKernel3..."
    git clone -q https://github.com/r0xx3z/Ak3.git -b Sweet AnyKernel3
else
    echo "AnyKernel3 directory already exists. Skipping clone."
fi


# GCC 64

if [ ! -d gcc64 ]; then
    git clone --depth=1 \
        https://github.com/greenforce-project/gcc-arm64 \
        -b main gcc64
fi

echo ""

# GCC 32

if [ ! -d gcc32 ]; then
    git clone --depth=1 \
        https://github.com/greenforce-project/gcc-arm \
        -b main gcc32
fi

echo ""
echo "========================================"
echo "  Toolchains installed successfully."
echo "========================================"
sleep 2
exit
