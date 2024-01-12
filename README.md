## What is this?

This is temporary repo containing cmake toolchain for compiling
code using Android NDK to WebAssembly.

## Overview

![compilation pipeline](screenshots/compilation-pipeline.png)

## Current state

We have a working prototype that lets us compile simple micro-benchmarks, the gzip benchmark
from the SPECINT2000 suite, and we have also compiled one of programs from ndk-samples
(`native-plasma`).

### Gzip from SPECINT2000

Gzip running on a Pixel 6a via `adb shell`:

![gzip benchmark](screenshots/running-gzip.png)

### Timing comparison

![timing comparison](screenshots/timing.png)

### Code size comparison

![code size comparison](screenshots/code-size.png)

## Pre-requisites

You will need Android NDK and since at the moment of writing this NDK toolchain
does not support wasm target, `clang` from Android OpenSource Project
toolchain. Moreover, you need the modified `wasm2c` from the forked WABT
repository.

1. (Optional) Create a working directory (or directories) to hold your copies of
   the NDK, the toolchain, and WABT. You can use the same directory for all
   three, or you can use different locations. The name `my_android_wasm` is
   arbitrary and chosen just for illustration here. Also, for brevity we use
   just this one single directory.  (We will later tie things together using
   environment variables. See below.)
   
   ```
   cd $HOME
   mkdir my_android_wasm
   cd my_android_wasm
   ```

2. Download NDK [here](https://developer.android.com/ndk/downloads). (At the
   time of this writing, the current version is `r26b`.)  Then uncompress it,
   e.g. like so, creating `$HOME/my_android_wasm/android-ndk-r26b`:
   
   ```
   unzip $HOME/Downloads/android-ndk-r26b-linux.zip
   ```

3. Clone toolchain from this [AOSP git
   repository](https://android-review.git.corp.google.com/admin/repos/platform/prebuilts/clang/host/linux-x86,general):
   
   ```
   git clone --depth 1 https://android.googlesource.com/platform/prebuilts/clang/host/linux-x86
   ```

   This creates `$HOME/my_android_wasm/linux-x86`.

4. Set `ANDROID_NDK_HOME` environment variable to NDK root:

   ```
   export ANDROID_NDK_HOME=$HOME/my_android_wasm/android-ndk-r26b
   ```

5. Set `ANDROID_CLANG_TOOLCHAIN` environment variable to clang toolchain root.
   Any version greater or equal to `r475365b` should work. The latest (and
   confirmed to be working) version as of the time of this writing is `r510928`:
   
   ```
   export ANDROID_CLANG_TOOLCHAIN=$HOME/my_android_wasm/linux-x86/clang-r510928
   ```
   
6. Check out the worked version of WABT (which includes `wasm2c`):

   ```
   git clone https://github.com/AndroidWasm/wabt
   ```
   
   This creates `$HOME/my_android_wasm/wabt`.

7. Build the WABT fork by typing `make` in the root of the checkout.

   ```
   cd wabt
   make
   cd ..
   ```
   
8. Set `WABT_HOME` to the root of the wabt checkout:

   ```
   export WABT_HOME=$HOME/my_android_wasm/wabt
   ```

## How to use the cmake toolchain

Go to cmake project and execute the following commands:

```
mkdir build
cd build
cmake --toolchain $(wasm_ndk_root)/cmake/toolchain/android_wasm.toolchain.cmake ..
cmake --build .
```

## (Optional) How to build android toolchain (in case you need to do some cherry-picks from upstream)

The main document on how to build android llvm toolchain can be found here:
https://android.googlesource.com/toolchain/llvm_android/

Before building add upstream remote to android llvm toolchain

```
cd toolchain/llvm-project
git remote add upstream https://github.com/llvm/llvm-project.git
git fetch upstream
```

create a local branch (for `toolchain/llvm-project`)

```
repo start upstream-patches .
```

The android toolchain is usually couple of month behind ToT - so these are
cherry pick needed to build compilable wasm binaries

```
git cherry-pick cb5bc756808367d53c870716ce42611a563421e8
```

Use following command while building to exclude windows toolchain and skip tests

```
python toolchain/llvm_android/build.py --no-build windows --skip-tests
```
