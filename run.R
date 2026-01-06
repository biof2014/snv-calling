library(matrixStats)
library(precrec)
library(io)

# Convert quality score from string to numeric representation
quality_score <- function(s) {
	# ! is assigned a score of 0
	# charToRaw returns hexadecimal, which needs to be converted to integer
	as.integer(charToRaw(s)) - as.integer(charToRaw("!"))
}

phred_to_numeric <- function(scores) {
	10^(- scores / 10)
}

read_data <- function(path) {
	lines <- readLines(file.path(path, "indicators.txt"));
	indicatorsl <- lapply(strsplit(lines, ""), as.integer);

	strings <- readLines(file.path(path, "errors.txt"));
	qualsl <- lapply(strings, quality_score);
	errorsl <- lapply(qualsl, phred_to_numeric);

	lines <- readLines(file.path(path, "genotypes.txt"));
	genotypes <- unlist(lapply(lines, as.integer));

	# merge the indicators list and errors list
	ds <- mapply(
		function(x, e, g) {
			list(x = x, e = e)
		},
		indicatorsl, errorsl,
		SIMPLIFY = FALSE
	);

	list(
		input = ds,
		genotype = genotypes	
	)
}

# d  a data list containing:
#   x  vector of read indicator (0: reference, 1: alternative)
#   e  vector of read error probabilities
call_one_snv_haploid <- function(d) {
	x <- d$x;
	e <- d$e;
	log.like <- c(
		# p(x | g == 0)
		sum( (1 - x)*log(1 - e) + x*log(e) ) ,
		# p(x | g == 1)
		sum( (1 - x)*log(e) + x*log(1 - e) )
	);
	
	log.prior <- log(1/2);

	log.post <- log.prior + log.like;
	log.post <- log.post - logSumExp(log.post);

	# minus 1 to convert from 1-based to 0-based index
	log.post
}

# ds  a list of data lists
call_snvs_haploid <- function(ds) {
	do.call(rbind, lapply(ds, call_one_snv_haploid))
}

data.haploid <- read_data("data/haploid");

calls.haploid <- call_snvs_haploid(data.haploid$input);

calls.fn.haploid <- filename("haploid", ext="rds", path="calls", date=NA);
qwrite(calls.haploid, calls.fn.haploid);

