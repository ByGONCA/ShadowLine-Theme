#!/usr/bin/env bash
# sample.sh

set -euo pipefail

name="ShadowLine"
count=3

for i in $(seq 1 "$count"); do
  echo "Hello, $name #$i"
done
