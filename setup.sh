#!/bin/bash
# Install R dependencies

set -euo pipefail
IFS=$'\n\t'

(
if [[ ! -f ./bin/rip ]]; then
	mkdir -p bin
	cd bin
	curl -L https://github.com/djhshih/rip/archive/v0.3.tar.gz |
		tar --strip-components=1 -xz
fi
)

./bin/rip install -r requirements-r.txt

