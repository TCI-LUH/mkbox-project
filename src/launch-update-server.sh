#!/bin/bash
base_dir="$(realpath $(dirname "$0"))"
export IMAGE_PATH="${IMAGE_PATH:-$base_dir/boxes}"
export PORT=${PORT:-5555}
export HOST=${HOST:-0.0.0.0}

"$base_dir/mkbox/tools/update-server"