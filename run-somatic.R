# Run somatic model

source("R/common.R")

data <- read_data("data/somatic");

# FIXME Replace with implementation of somatic model
calls <- matrix(0, nrow=length(data$genotype), ncol=3);
write_output(calls, "somatic");

