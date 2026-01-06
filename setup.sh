#!/bin/bash
# Set up environment

set -euo pipefail
IFS=$'\n\t'

# Install R dependencies

mkdir -p bin

(
cd bin
curl -L https://github.com/djhshih/rip/archive/v0.3.tar.gz |
	tar --strip-components=1 -xz
)

./bin/rip install -r requirements-r.txt

