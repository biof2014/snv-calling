# Run germline haploid models

library(io)
library(matrixStats)

source("R/common.R");

# Call SNV under germline haploid model
# param x  vector of read indicator (0: reference, 1: alternative)
# param e  vector of read error probabilities
call_snv_haploid <- function(x, e) {
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

# param ds  a list of data lists
call_snvs_haploid <- function(ds) {
	do.call(rbind, lapply(ds, function(d) call_snv_haploid(d$x, d$e)))
}

input <- read_input("data/haploid");

calls <- call_snvs_haploid(input);

write_output(calls, "haploid");

