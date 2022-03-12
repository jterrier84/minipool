#!/usr/bin/env bash

set -x
CNVERSION="1.34.1"

docker build -t jterrier84/armada-cn:${CNVERSION} \
  -f armada-cn-arm64.dockerfile . \
  2>&1 \
  | tee /tmp/build.logs
