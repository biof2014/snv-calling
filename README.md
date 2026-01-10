# SNV calling

In this project, you will implement statistical models in R to call single
nucleotide variants (SNVs) using summarized sequencing data.


## Instructions

1. Install R packages by
```
./setup.sh
```

2. Run the model evaluation by
```
./evaluate-dev.sh
```
If successful, the evaluation results will be in `evaluate-dev.json`.

3. As the evaluation results show, the stub implementations of the 
   diploid and somatic models are ineffective.
   Implement your diploid model in `run-diploid.R`.
   Implement your somatic model in `run-somatic.R`.
   As you develop your models, re-run the model evaluation to see how
   your models perform.

4. Commit your code *regularly* by
```
git add run-diploid.R run-somatic.R
git commit -m "Describe your changes"
```

5. Test your code on GitHub *occasionally* by
```
git push
```
Then, you can see your workflow status under the `Actions` tab
at your Github project repo.


## Specification

The output of your model should be a log probability matrix (or at least a score
matrix) with *J* rows and *K* columns, where *J* is the number of loci, and *K*
is the number of genotype levels. For the diploid and somatic models, *K* = 3.

This output must be saved in the `calls` directory with file names `diploid.rds`
and `somatic.rds` in RDS format.


## Important remarks for students

- Your model must *not* use the genotype. If `run-diploid.R` and `run-somatic.R`
  reads the genotype or any derivative thereof, your prediction score will be
  set to 0.
- Any attempts to temper with the grading system will result in a grade of 0
  for this project.
- Do *not* change any other files. Your models will be evaluated in a new
  clone of the original Github project repo, and 
  only your `run-diploid.R` and `run-somatic.R` will be copied over.
- Do *not* share your code with anyone.
  If your code is similar to another person's code, your novelty
  score will be low.
- Ensure that your models do *not* depend on packages that are not in
  `requirements-r.txt`, and do *not* add packages to `requirements-r.txt`.

