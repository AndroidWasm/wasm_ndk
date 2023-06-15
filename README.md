## What is this?

This is temporary repo containing cmake toolchain for compiling
code using Android NDK to WebAssembly. The project is currently
in experimental stage so it would either be abandoned or merged
to Android NDK in some way or form.

## Pre-requisites

You will need Android NDK and since at the moment of writing
this NDK toolchain does not support wasm target, - clang
from Andorid OpenSource Project toolchain.

1. Download NDK [here](https://developer.android.com/ndk/downloads)
1. Clone toolchain from this [AOSP git repository](https://android-review.git.corp.google.com/admin/repos/platform/prebuilts/clang/host/linux-x86,general):
   ```
   git clone --depth 1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86
   ```
1. Set ANDROID_NDK environment variable to NDK root
1. Set ANDROID_CLANG_TOOLCHAIN environment variable to clang toolchain root
   (example: (toolchain repo root)/clang-r487747)

## How to use the cmake toolchain

Go to cmake project and execute the following commands
```
mkdir build
cmake --toolchain $(wasm_ndk_root)/cmake/toolchain/android_wasm.toolchain.cmake ..
cmake --build .
```
