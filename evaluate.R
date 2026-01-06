
calls <- qread("calls/haploid.rds");

# evaluate calls against ground truth
scores <- calls.haploid[, 2];

aucs <- auc(evalmod(scores = scores, labels = data.haploid$genotype));

auroc <- aucs$aucs[aucs$curvetypes == "ROC"];

message("AUROC: ", auroc)


