library(io)
library(precrec)
library(matrixStats)

source("R/common.R")

# make genotype calls based on highest probability
# using probs matrix (locus x genotype levels)
call_genotype <- function(lprobs) {
	# substract 1 to convert from 1-based to 0-based index
	apply(lprobs, 1, which.max) - 1
}

get_zygosity_lprobs <- function(lprobs) {
	# drop the wildtype log probs
	lprobs <- lprobs[, -1];
	# re-normalize
	t(apply(lprobs, 1, function(x) x - logSumExp(x)))
}

# evaluate calls against ground truth
get_auroc <- function(scores, labels) {
	ev <- evalmod(scores = scores, labels = labels);
	aucs <- auc(ev);
	aucs$aucs[aucs$curvetypes == "ROC"]
}


g.haploid <- read_data("data/haploid")$genotype;
lprobs.haploid <- qread("calls/haploid.rds");

g.diploid <- read_data("data/diploid")$genotype;
lprobs.diploid <- qread("calls/diploid.rds");
lprobs.mutant <- lprobs.diploid[, 2] + lprobs.diploid[, 3];

# drop the wildtype and determine the zygosity
zygosity <- ifelse(g.diploid == 0, NA, g.diploid - 1);
valid <- !is.na(zygosity);
zygosity <- zygosity[valid];
lprobs.homo <- get_zygosity_lprobs(lprobs.diploid[valid, ])[, 2];

cmat.diploid <- table(g.diploid, call_genotype(lprobs.diploid));
print(cmat.diploid)

out <- list(
	germline.haploid = list(
		cmat = table(g.haploid, call_genotype(lprobs.haploid)),
		auroc = list(
			mutation = get_auroc(lprobs.haploid[, 2], g.haploid)
		)
	),
	germline.diploid = list(
		cmat = cmat.diploid,
		auroc = list(
			mutation = get_auroc(lprobs.mutant, g.diploid > 0),
			zygosity = get_auroc(lprobs.homo, zygosity)
		)
	)
);

print(out)
qwrite(out, "evaluate-dev.json")

