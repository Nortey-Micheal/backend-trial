#!/usr/bin/env sh
set -eu
OUT="\${TMPDIR:-/tmp}/mobile-money-sanitizer-tests"
"\${CC:-cc}" -std=c11 -D_POSIX_C_SOURCE=200809L -Wall -Wextra -Werror -Wconversion -Wsign-conversion -fsanitize=address,undefined -fno-omit-frame-pointer -g c-exercises/01-bounded-copy.c c-exercises/02-checked-sum.c c-exercises/03-parse-amount.c c-exercises/test.c -o "$OUT"
ASAN_OPTIONS=detect_leaks=1:halt_on_error=1 UBSAN_OPTIONS=halt_on_error=1 "$OUT"
