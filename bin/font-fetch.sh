#!/usr/bin/env sh

# fetch font
root_dir=$(dirname $(dirname $(readlink -f "${0}")))

git clone https://github.com/theleagueof/raleway.git \
${root_dir}/static/font
