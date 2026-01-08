# Run germline diploid models

library(io)
library(matrixStats)

source("R/common.R");

data <- read_data("data/diploid");

# FIXME ineffective model
bad_model <- function(d) {
	n.zeros <- sum(d$x == 0);
	n.ones <- sum(d$x == 1);
	n.total <- n.zeros + n.ones;
	freq <-  n.ones / n.total;
	freq2 <- freq/2;
	c(
		1 - freq,
		freq2,
		freq2
	)
}

calls <- do.call(rbind, lapply(data$input, bad_model));
write_output(calls, "diploid");

