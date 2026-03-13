library(io)
library(jsonlite)
library(precrec)
library(matrixStats)

source("R/common.R")

# make genotype calls based on highest probability
# using probs matrix (locus x genotype levels)
call_genotype <- function(lprobs) {
	# substract 1 to convert from 1-based to 0-based index
	apply(lprobs, 1, which.max) - 1
}

get_homozygous_lprobs <- function(lprobs) {
	# keep only the heterozygous and homozygous lprobs
	lprobs <- lprobs[, 2:3];
	# re-normalize
	t(apply(lprobs, 1, function(x) x - logSumExp(x)))
}

# prepare ground truth and log probs to prediction tasks
prepare_data <- function(genotype, lprobs) {
	# combine heterozygous and homozygous together for mutant prediction task
	mutant <- as.integer(genotype > 0);
	lprobs.mutant <- apply(lprobs[, -1, drop=FALSE], 1, logSumExp);
	# drop the wildtype for homozygous prediction task
	homozygous <- ifelse(genotype %in% 1:2, genotype - 1, NA);
	valid <- !is.na(homozygous);
	homozygous <- homozygous[valid];
	lprobs.homo <- get_homozygous_lprobs(lprobs[valid, ])[, 2];
	list(
		mutant = mutant, lprobs.mutant = lprobs.mutant,
		homozygous = homozygous, lprobs.homo = lprobs.homo, valid = valid
	)
}

# evaluate calls against ground truth
get_auroc <- function(scores, labels) {
	ev <- evalmod(scores = scores, labels = labels);
	aucs <- auc(ev);
	aucs$aucs[aucs$curvetypes == "ROC"]
}


# germline haploid

g.haploid <- read_genotype("data/haploid");
lprobs.haploid <- qread("calls/haploid.rds");
stopifnot(ncol(lprobs.haploid) == 2)
stopifnot(nrow(lprobs.haploid) == length(g.haploid));

confusion_matrix <- function(pred, truth) {
	levs <- sort(unique(truth));
	truth <- factor(truth, levels=levs);
	pred <- factor(pred, levels=levs);
	table(truth, pred)
}

cmat.haploid <- confusion_matrix(call_genotype(lprobs.haploid), g.haploid);
auroc.haploid <- get_auroc(lprobs.haploid[, 2], g.haploid);

germline.haploid <- list(
	cmat = as.numeric(cmat.haploid),
	auroc = list(
		mutation = get_auroc(lprobs.haploid[, 2], g.haploid)
	)
);


# germline diploid

g.diploid <- read_genotype("data/diploid");
lprobs.diploid <- qread("calls/diploid.rds");
stopifnot(ncol(lprobs.diploid) == 3)
stopifnot(nrow(lprobs.diploid) == length(g.diploid));

cmat.diploid <- confusion_matrix(call_genotype(lprobs.diploid), g.diploid);

d.diploid <- prepare_data(g.diploid, lprobs.diploid);

germline.diploid = list(
	cmat = as.numeric(cmat.diploid),
	auroc = list(
		mutation = get_auroc(d.diploid$lprobs.mutant, d.diploid$mutant),
		homozygous = get_auroc(d.diploid$lprobs.homo, d.diploid$homozygous)
	)
);


# somatic

g.somatic <- read_genotype("data/somatic/tumour");
# collapse joint genotypes involving germline variants together
g.somatic[g.somatic > 2] <- 0;

lprobs.somatic <- qread("calls/somatic.rds");
stopifnot(ncol(lprobs.diploid) >= 3)
stopifnot(nrow(lprobs.somatic) == length(g.somatic));

cmat.somatic <- confusion_matrix(call_genotype(lprobs.somatic), g.somatic);

d.somatic <- prepare_data(g.somatic, lprobs.somatic);

somatic <- list(
	cmat = as.numeric(cmat.somatic),
	auroc = list(
		mutation = get_auroc(d.somatic$lprobs.mutant, d.somatic$mutant),
		homozygous = get_auroc(d.somatic$lprobs.homo, d.somatic$homozygous)
	)
);

aucs <- c(
	germline.diploid$auroc$mutation,
	germline.diploid$auroc$homozygous,
	somatic$auroc$mutation,
	somatic$auroc$homozygous
);

c0 <- 0.5;
aucs.norm <- pmax(0, aucs - c0) / (1 - c0);

grade.total <- 20;
grade <- round(sum(aucs.norm * grade.total / length(aucs.norm)));

# output evaluation results

out <- list(
	germline.haploid = germline.haploid,
	germline.diploid = germline.diploid,
	somatic = somatic,
	grade = list (
		pass = grade,
		total = grade.total
	)
);

message(toJSON(out, pretty=TRUE))
write_json(out, "evaluate.json")

