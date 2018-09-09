#! /usr/bin/env bash

## *****************************************************************************
##  
## Description : android_build script is used to compile CMake projects for
##               android.
##
##               Prerequisites:
##               1. Setup android toolchains using README.md present in 
##                  cocosdk-java/jni
##
## *****************************************************************************
##/*===============================================================================*/
##/* Copyright (c) 2018 Elear Solutions Tech Private Limited. All rights reserved. */
##/* To any person (the "Recipient") obtaining a copy of this software and         */
##/* associated documentation files (the "Software"):                              */
##/*                                                                               */
##/* All information contained in or disclosed by this software is confidential    */
##/* and proprietary information of Elear Solutions Tech Private Limited and all   */
##/* rights therein are expressly reserved. By accepting this material the         */
##/* recipient agrees that this material and the information contained therein is  */
##/* held in confidence and in trust and will NOT be used, copied, modified,       */
##/* merged, published, distributed, sublicensed, reproduced in whole or in part,  */
##/* nor its contents revealed in any manner to others without the express         */
##/* written permission of Elear Solutions Tech Private Limited.                   */
##/*===============================================================================*/

mkdir build_android
mkdir build_android/arm64-v8a
mkdir build_android/armeabi-v7a
mkdir build_android/x86
mkdir build_android/x86_64
cd build_android
ANDROID_TOOLCHAINS_DIR="/opt/elear-solutions"

#looping for each complier
for ANDROID_TOOLCHAIN_DIR in "toolchain_aarch64_v8a_21" "toolchain_armeabi_v7a_19" "toolchain_x86_19" "toolchain_x86_64_21"
do
  INSTALL_PREFIX="${ANDROID_TOOLCHAINS_DIR}/${ANDROID_TOOLCHAIN_DIR}/sysroot/usr"
  #Setting output dir
  case "$ANDROID_TOOLCHAIN_DIR" in
     "toolchain_aarch64_v8a_21")
        MAKEDIR="arm64-v8a"
        COMPILER_PREFIX="aarch64-linux-android"
        ;;
     "toolchain_armeabi_v7a_19")
        MAKEDIR="armeabi-v7a" 
        COMPILER_PREFIX="arm-linux-androideabi"
        ;;
     "toolchain_x86_19")
        MAKEDIR="x86" 
        COMPILER_PREFIX="i686-linux-android"
        ;;
     "toolchain_x86_64_21")
        MAKEDIR="x86_64"
        COMPILER_PREFIX="x86_64-linux-android"
        ;;
  esac
  export ANDROID_TOOLCHAIN_ROOT="${ANDROID_TOOLCHAINS_DIR}/${ANDROID_TOOLCHAIN_DIR}"

  ANDROID_TOOLCHAIN_BIN="${ANDROID_TOOLCHAIN_ROOT}/bin"
  ANDROID_TOOLCHAIN_SYSROOT_DIR="${ANDROID_TOOLCHAIN_ROOT}/sysroot"
  ANDROID_TOOLCHAIN_LD_LIB="$ANDROID_TOOLCHAIN_SYSROOT_DIR/usr/lib"

  export CFLAGS="--sysroot=${ANDROID_TOOLCHAIN_SYSROOT_DIR}"
  export CXXFLAGS="--sysroot=${ANDROID_TOOLCHAIN_SYSROOT_DIR}"
  export LDFLAGS="-L${ANDROID_TOOLCHAIN_LD_LIB}"

  export CC=${ANDROID_TOOLCHAIN_BIN}/${COMPILER_PREFIX}-clang
  export CPP=${ANDROID_TOOLCHAIN_BIN}/${COMPILER_PREFIX}-cpp
  export CXX=${ANDROID_TOOLCHAIN_BIN}/${COMPILER_PREFIX}-clang++
  export LD=${ANDROID_TOOLCHAIN_BIN}/${COMPILER_PREFIX}-ld
  export AR=${ANDROID_TOOLCHAIN_BIN}/${COMPILER_PREFIX}-ar
  export RANLIB=${ANDROID_TOOLCHAIN_BIN}/${COMPILER_PREFIX}-ranlib
  export STRIP=${ANDROID_TOOLCHAIN_BIN}/${COMPILER_PREFIX}-strip 

  cd ${MAKEDIR}
  CC=${CC} cmake -DPlatform:STRING=android -DCMAKE_INSTALL_PREFIX:PATH=${INSTALL_PREFIX} ../..
  make
  make install
  cd ..
done
