library(io)
library(precrec)

source("R/common.R")

data.haploid <- read_data("data/haploid");
y <- data.haploid$genotype;

calls.haploid <- qread("calls/haploid.rds");

# confusion matrix based on most probable genotype
y.hat <- apply(calls.haploid, 1, which.max) - 1;
table(y.hat, y)

# evaluate calls against ground truth
scores <- calls.haploid[, 2];
ev <- evalmod(scores = scores, labels = y);
aucs <- auc(ev);
auroc <- aucs$aucs[aucs$curvetypes == "ROC"];

out <- list(
	haploid = auroc
);

print(out)
qwrite(out, "evaluate-dev.json")
