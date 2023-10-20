set(ANDROID_NDK_HOME $ENV{ANDROID_NDK_HOME})
set(ANDROID_TOOLCHAIN_ROOT $ENV{ANDROID_CLANG_TOOLCHAIN})

if ("${ANDROID_NDK_HOME}" STREQUAL "")
  message(FATAL_ERROR "ANDROID_NDK_HOME not set")
endif()

if ("${ANDROID_TOOLCHAIN_ROOT}" STREQUAL "")
  message(FATAL_ERROR "ANDROID_TOOLCHAIN_ROOT not set")
endif()

include("${ANDROID_NDK_HOME}/build/cmake/android.toolchain.cmake")

#set(ANDROID_SYSROOT_ABI wasm64)
#set(CMAKE_SYSTEM_PROCESSOR wasm64)
#set(ANDROID_TOOLCHAIN_NAME wasm64-linux-android)
#set(ANDROID_LLVM_TRIPLE wasm64-none-linux-android)

set(ANDROID_WASM 1)

set(WASM_TRIPLE wasm64-unknown-unknown)

set(WASM_LIBRARY_PATH "${CMAKE_CURRENT_LIST_DIR}/../../libs")
set(WASM_PLATROFM_SPECIFIC_INCLUDE_PATH "${CMAKE_CURRENT_LIST_DIR}/../../include/wasm64")

list(APPEND ANDROID_WASM_COMPILER_FLAGS
  -g
  -DANDROID
  --no-standard-libraries
  -mllvm
  -wasm-omit-64-bit-function-pointer-cast
  -fvisibility=default
  -mno-bulk-memory
  -I${WASM_PLATROFM_SPECIFIC_INCLUDE_PATH}
  -I${CMAKE_SYSROOT}/usr/include)

list(APPEND ANDROID_WASM_COMPILER_FLAGS_CXX "-I${CMAKE_SYSROOT}/usr/include/c++/v1")

# This is a hack to enable pthread support in __config include file
# TODO: This is probably not be entirely correct.
list(APPEND ANDROID_WASM_COMPILER_FLAGS_CXX "-D__wasi__")

set(CMAKE_C_COMPILER_TARGET   ${WASM_TRIPLE})
set(CMAKE_CXX_COMPILER_TARGET ${WASM_TRIPLE})
set(CMAKE_ASM_COMPILER_TARGET ${WASM_TRIPLE})
set(CMAKE_C_COMPILER_EXTERNAL_TOOLCHAIN   "${ANDROID_TOOLCHAIN_ROOT}")
set(CMAKE_CXX_COMPILER_EXTERNAL_TOOLCHAIN "${ANDROID_TOOLCHAIN_ROOT}")
set(CMAKE_ASM_COMPILER_EXTERNAL_TOOLCHAIN "${ANDROID_TOOLCHAIN_ROOT}")
set(CMAKE_C_COMPILER "${ANDROID_TOOLCHAIN_ROOT}/bin/clang")
set(CMAKE_CXX_COMPILER "${ANDROID_TOOLCHAIN_ROOT}/bin/clang++")

#list(APPEND ANDROID_WASM_LINKER_FLAGS "-L${WASM_LIBRARY_PATH}")
list(APPEND ANDROID_WASM_LINKER_FLAGS "-Wl,--emit-relocs")
list(APPEND ANDROID_WASM_LINKER_FLAGS "-Wl,--no-entry")
list(APPEND ANDROID_WASM_LINKER_FLAGS "-mno-bulk-memory")
list(APPEND ANDROID_WASM_LINKER_FLAGS "-Wl,--allow-undefined-file=${WASM_LIBRARY_PATH}/ndk_symbols.txt")

string(REPLACE ";" " " ANDROID_WASM_LINKER_FLAGS           "${ANDROID_WASM_LINKER_FLAGS}")
string(REPLACE ";" " " ANDROID_WASM_COMPILER_FLAGS         "${ANDROID_WASM_COMPILER_FLAGS}")
string(REPLACE ";" " " ANDROID_WASM_COMPILER_FLAGS_CXX     "${ANDROID_WASM_COMPILER_FLAGS_CXX}")
set(CMAKE_SHARED_LINKER_FLAGS "${ANDROID_WASM_LINKER_FLAGS}")
set(CMAKE_EXE_LINKER_FLAGS "${ANDROID_WASM_LINKER_FLAGS}")
set(CMAKE_C_FLAGS "${ANDROID_WASM_COMPILER_FLAGS}")
set(CMAKE_CXX_FLAGS "${ANDROID_WASM_COMPILER_FLAGS} ${ANDROID_WASM_COMPILER_FLAGS_CXX}")

set(CMAKE_POSITION_INDEPENDENT_CODE FALSE)

# Is this needed?
set(CMAKE_MODULE_LINKER_FLAGS "${ANDROID_WASM_LINKER_FLAGS}")

# TODO: we need this to be present at some point in the future
set(CMAKE_C_STANDARD_LIBRARIES_INIT "")
set(CMAKE_CXX_STANDARD_LIBRARIES_INIT "${CMAKE_C_STANDARD_LIBRARIES_INIT}")

