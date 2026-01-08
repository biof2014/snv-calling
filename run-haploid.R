# Run germline haploid models

library(io)
library(matrixStats)

source("R/common.R");

# Germline haploid model

# d  a data list containing:
#   x  vector of read indicator (0: reference, 1: alternative)
#   e  vector of read error probabilities
call_one_snv_haploid <- function(d) {
	x <- d$x;
	e <- d$e;

	log.prior <- log(1/2);
	log.like <- c(
		# p(x | g == 0)
		sum( (1 - x)*log(1 - e) + x*log(e) ) ,
		# p(x | g == 1)
		sum( (1 - x)*log(e) + x*log(1 - e) )
	);
	log.post <- log.prior + log.like;
	log.post <- log.post - logSumExp(log.post);

	# minus 1 to convert from 1-based to 0-based index
	log.post
}

# ds  a list of data lists
call_snvs_haploid <- function(ds) {
	do.call(rbind, lapply(ds, call_one_snv_haploid))
}

data <- read_data("data/haploid");

calls <- call_snvs_haploid(data$input);

write_output(calls, "haploid");

