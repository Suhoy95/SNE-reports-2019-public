#!/bin/bash
# https://serverfault.com/a/790628

echo -n 02; od -t x1 -An -N 5 /dev/urandom | tr ' ' ':'
