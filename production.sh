#!/bin/bash
# Evaluate models on production data

set -euo pipefail
IFS=$'\n\t'

if (( $# < 1 )); then
	echo "usage: ${0##*/} <PROD_KEY>"
	exit 1
fi

key=$1

# get new copy of template repo
rm -rf prod
git clone --depth=1 https://github.com/biof2014/snv-calling prod

# production environment

cd prod

# get production data
rm -rf data
git clone --depth=1 https://${key}@github.com/biof2014/snv-calling-prod data

# copy over models
cp ../run-diploid.R ../run-somatic.R .

./evaluate.sh

