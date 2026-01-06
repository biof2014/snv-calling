library(io)
library(precrec)

source("R/common.R")


# make genotype calls based on highest probability
# using probs matrix (locus x genotype levels)
call_genotype <- function(probs) {
	# substract 1 to convert from 1-based to 0-based index
	apply(probs, 1, which.max) - 1
}

# evaluate calls against ground truth
get_auroc <- function(scores, labels) {
	ev <- evalmod(scores = scores, labels = labels);
	aucs <- auc(ev);
	aucs$aucs[aucs$curvetypes == "ROC"]
}


y.haploid <- read_data("data/haploid")$genotype;
calls.haploid <- qread("calls/haploid.rds");

out <- list(
	haploid = list(
		cmat = table(call_genotype(calls.haploid), y.haploid),
		auroc = get_auroc(calls.haploid[, 2], y.haploid)
	)
);

print(out)
qwrite(out, "evaluate-dev.json")

