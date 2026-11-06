#!/bin/bash

set -euo pipefail

SCRIPTS_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" && echo "$PWD")
pushd "${SCRIPTS_DIR}/../build-sysroots"
./build_sysroots.sh
popd

cd "${SCRIPTS_DIR}/../postgres_test_builds"
bazel test //...

# with_readline is off by default, so nothing above compiles psql's readline
# code. One release per major catches a bad define set or a missing dep.
bazel build --@postgres_config//:with_readline=true \
  @postgres_16_14//:psql \
  @postgres_17_10//:psql \
  @postgres_18_4//:psql
