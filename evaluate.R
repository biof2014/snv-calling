library(io)
library(precrec)

source("R/common.R")

data.haploid <- read_data("data/haploid");
calls.haploid <- qread("calls/haploid.rds");

# evaluate calls against ground truth
scores <- calls.haploid[, 2];
aucs <- auc(evalmod(scores = scores, labels = data.haploid$genotype));
auroc <- aucs$aucs[aucs$curvetypes == "ROC"];

message("haploid: ", paste(auroc, collapse=" "))

