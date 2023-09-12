#!/bin/bash

set -o errexit

# Check ot the hello directory (where this script lives)
SOURCE=${BASH_SOURCE[0]}
cd $(dirname $SOURCE)

# Build the 'hello' project using the android_wasm toolchain file.
# The result of this will be a 'hello' wasm binary 
echo '=== Phase 1: Build Android project to wasm file: `build/hello`'
echo ''
mkdir -p build
cmake --toolchain ../../cmake/toolchain/android_wasm.toolchain.cmake -GNinja -S . -B build
cmake --build build

# This should should that the 'hello' binary is a wasm file
file build/hello

# Convert the wasm to C using wasm2c
mkdir -p wasm2c_out
echo ''
echo '=== Phase 2: Run wasm2c `build/hello` -> `wasm2c_out/hello_generated.c`'
../../bin/wasm2native.py build/hello wasm2c_out

echo '=== Phase 3: (TODO) Build hello_generated.c using the NDK'
