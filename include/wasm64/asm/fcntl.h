#ifndef WASM64_ASM_FCNTL_H_
#define WASM64_ASM_FCNTL_H_

// Use ARM constants for now
// TODO: we probably want to stick with generic ones for wasm64
#define O_DIRECTORY 040000
#define O_NOFOLLOW 0100000
#define O_DIRECT 0200000
#define O_LARGEFILE 0400000
#include <asm-generic/fcntl.h>

#endif  // WASM64_ASM_FCNTL_H_
