#!/usr/bin/env python3
#
# Copyright (c) 2023 The Android Open Source Project
# All rights reserved.
#
# Redistribution and use in source and binary forms, with or without
# modification, are permitted provided that the following conditions are met:
#
# 1. Redistributions of source code must retain the above copyright notice, this
#    list of conditions and the following disclaimer.
#
# 2. Redistributions in binary form must reproduce the above copyright notice,
#    this list of conditions and the following disclaimer in the documentation
#    and/or other materials provided with the distribution.
#
# THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
# AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
# DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
# SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
# CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
# OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
# OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#

import argparse
import os
import shutil
import subprocess
import sys


def get_wabt_home(args):
  if args.wabt_home:
    return args.wabt_home
  wasm2c = shutil.which('wasm2c')
  if wasm2c:
    return os.path.dirname(os.path.dirname(wasm2c))
  wabt_home = os.environ.get('WABT_HOME')
  if not wabt_home:
    raise Exception('Cant find wasm2c: WABT_HOME environment variable is not set and --wabt_home option is not specified')
  return wabt_home


def main(argv):
  parser = argparse.ArgumentParser(description='Convert Wasm to c++ and cmake files ready to compile with Andorid NDK')
  parser.add_argument('--wabt_home')
  parser.add_argument('wasm_binary')
  parser.add_argument('output_dir', help='Output directory')

  args = parser.parse_args()

  wasm_binary = args.wasm_binary
  output_dir = args.output_dir

  wabt_home = get_wabt_home(args)

  path_to_wasm2c = wabt_home + "/bin/wasm2c"
  output_file = output_dir + "/" + os.path.basename(wasm_binary) + '_generated.c'

  p = subprocess.Popen([path_to_wasm2c, '--experimental', '--disable-sandbox',
                        '--enable-memory64',
                        '-o', output_file, wasm_binary],
                       shell=False)


if __name__ == "__main__":
  sys.exit(main(sys.argv))
