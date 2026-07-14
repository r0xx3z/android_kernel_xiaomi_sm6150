#!/bin/bash
# By Ll0rens

echo
echo "================================="
echo " Installing build toolchains..."
echo "================================="
echo

################################
# Neutron Clang
################################

if [ ! -d "clang" ]; then
    echo "[*] Installing Neutron Clang..."

    mkdir -p clang
    pushd clang >/dev/null

    curl -LO https://raw.githubusercontent.com/Neutron-Toolchains/antman/main/antman
    chmod +x antman

    ./antman -S
    ./antman --patch=glibc

    popd >/dev/null
else
    echo "[✓] clang already exists."
fi

echo

################################
# GCC 64
################################

if [ ! -d "gcc64" ]; then
    echo "[*] Cloning GCC64..."

    git clone \
        --depth=1 \
        https://github.com/greenforce-project/gcc-arm64 \
        -b main \
        gcc64
else
    echo "[✓] gcc64 already exists."
fi

echo

################################
# GCC 32
################################

if [ ! -d "gcc32" ]; then
    echo "[*] Cloning GCC32..."

    git clone \
        --depth=1 \
        https://github.com/greenforce-project/gcc-arm \
        -b main \
        gcc32
else
    echo "[✓] gcc32 already exists."
fi

echo

################################
# AnyKernel3
################################

if [ ! -d "AnyKernel3" ]; then
    echo "[*] Cloning AnyKernel3..."

    git clone \
        --depth=1 \
        https://github.com/r0xx3z/Ak3.git \
        -b Sweet \
        AnyKernel3
else
    echo "[✓] AnyKernel3 already exists."
fi

echo
echo "======================================"
echo " Toolchains installed successfully!"
echo "======================================"
echo

echo "Installed toolchains:"
echo "  Clang      : $(pwd)/clang"
echo "  GCC64      : $(pwd)/gcc64"
echo "  GCC32      : $(pwd)/gcc32"
echo "  AnyKernel3 : $(pwd)/AnyKernel3"
echo
