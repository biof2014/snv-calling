# Run germline diploid models

source("R/common.R");

input <- read_input("data/diploid");

# FIXME Replace with implementation of diploid model
call_snv_diploid <- function(x, e) {
	n.zeros <- sum(x == 0);
	n.ones <- sum(x == 1);
	n.total <- n.zeros + n.ones;
	freq <-  n.ones / n.total;
	freq2 <- freq/2;
	c(
		1 - freq,
		freq2,
		freq2
	)
}

calls <- do.call(rbind, lapply(input, function(d) call_snv_diploid(d$x, d$e)));
write_output(calls, "diploid");

