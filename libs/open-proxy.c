#include <fcntl.h>
#include <stdarg.h>

extern int wasm_open2(const char *pathname, int flags);
extern int wasm_open3(const char *pathname, int flags, mode_t mode);

int open(const char *pathname, int flags, ...) {
  if ((flags & (O_CREAT | O_TMPFILE)) == 0) {
    return wasm_open2(pathname, flags);
  }
  va_list ap;
  va_start(ap, flags);
  mode_t mode = va_arg(ap, mode_t);
  va_end(ap);
  return wasm_open3(pathname, flags, mode);
}
