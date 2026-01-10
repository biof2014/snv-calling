# Run somatic model

source("R/common.R")

normal <- read_input("data/somatic/normal");
tumour <- read_input("data/somatic/tumour");

# FIXME Replace with implementation of somatic model
calls <- matrix(0, nrow=length(tumour), ncol=3);
write_output(calls, "somatic");

