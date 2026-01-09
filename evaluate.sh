#!/bin/bash
# Evaluate model under development scenario

set -euo pipefail
IFS=$'\n\t'

# run models
Rscript run-haploid.R
Rscript run-diploid.R
Rscript run-somatic.R

# evaluate model outputs
Rscript evaluate.R

